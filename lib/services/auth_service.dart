import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_strings.dart';
import '../models/naap_user.dart';
import '../utils/login_guard.dart';
import 'session_store.dart';

/// Error shown to the user. [code] is for tests and logs, [message] is for the screen.
class AuthException implements Exception {
  final String code;
  final String message;
  final Duration? retryAfter;

  const AuthException(this.code, this.message, {this.retryAfter});

  @override
  String toString() => 'AuthException($code): $message';
}

/// Sprint 1 accounts (US-001 to US-008).
///
/// LOCAL MODE: this version keeps accounts on the phone so the team can run and test
/// the screens before Firebase is set up. Emails (verification, password reset) cannot
/// really be sent in local mode, so the screens offer a "demo" button that does what
/// the email link would do. When the team connects Firebase, only this file changes:
/// the screens call the same methods.
///
/// Storage layout: one key per email, so finding a user is O(1) instead of
/// loading and searching a list of all users.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const Duration resetLinkLifetime = Duration(minutes: 30);

  final SessionStore _session = SessionStore();
  final Random _random = Random.secure();

  NaapUser? _currentUser;
  NaapUser? get currentUser => _currentUser;

  /// Only used in local mode so the demo button can open the "email link".
  String? lastDemoResetToken;

  String _userKey(String email) => 'naap_user_${email.trim().toLowerCase()}';
  String _guardKey(String email) => 'naap_guard_${email.trim().toLowerCase()}';
  String _resetKey(String token) => 'naap_reset_$token';

  // ---------- password hashing ----------

  String _newSalt() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  /// SHA-256 of salt + password. The salt makes two equal passwords produce
  /// different hashes, so a stolen copy of the store can't be matched against a table.
  String _hash(String salt, String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  /// Compares two hashes in constant time, so timing doesn't leak how many characters matched.
  bool _sameHash(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }

  Future<Map<String, dynamic>?> _readUser(
      SharedPreferences prefs, String email) async {
    final raw = prefs.getString(_userKey(email));
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> _writeUser(
          SharedPreferences prefs, String email, Map<String, dynamic> data) =>
      prefs.setString(_userKey(email), jsonEncode(data));

  NaapUser _toUser(String email, Map<String, dynamic> data) => NaapUser(
        name: data['name'] as String,
        email: email.trim().toLowerCase(),
        emailVerified: (data['verified'] as bool?) ?? false,
      );

  // ---------- US-001 sign up ----------

  Future<NaapUser> signUp(
      {required String name,
      required String email,
      required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    if (await _readUser(prefs, email) != null) {
      throw AuthException('email-taken', AppStrings.emailTaken);
    }
    final salt = _newSalt();
    final data = {
      'name': name.trim(),
      'salt': salt,
      'hash': _hash(salt, password),
      'verified': false,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };
    await _writeUser(prefs, email, data);
    final user = _toUser(email, data);
    _currentUser = user;
    await _session.save(user.email);
    await sendVerificationEmail();
    return user;
  }

  // ---------- US-002 Google ----------

  Future<NaapUser> signInWithGoogle() async {
    throw AuthException(
        'google-needs-firebase', AppStrings.googleNeedsFirebase);
  }

  // ---------- US-003 log in with lockout ----------

  Future<LoginGuard> _readGuard(SharedPreferences prefs, String email) async {
    final raw = prefs.getString(_guardKey(email));
    if (raw == null) return LoginGuard();
    return LoginGuard.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<NaapUser> logIn(
      {required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final guard = await _readGuard(prefs, email);

    final wait = guard.remainingLock(now);
    if (wait != null) {
      throw AuthException(
          'locked', AppStrings.tooManyTries(LoginGuard.describe(wait)),
          retryAfter: wait);
    }

    final data = await _readUser(prefs, email);
    if (data == null ||
        !_sameHash(
            _hash(data['salt'] as String, password), data['hash'] as String)) {
      // Count failures even for unknown emails, so the response never reveals which emails exist.
      final lockedNow = guard.recordFailure(now);
      await prefs.setString(_guardKey(email), jsonEncode(guard.toJson()));
      if (lockedNow) {
        throw AuthException('locked',
            AppStrings.tooManyTries(LoginGuard.describe(LoginGuard.lockTime)),
            retryAfter: LoginGuard.lockTime);
      }
      throw AuthException('wrong-credentials', AppStrings.wrongCredentials);
    }

    guard.recordSuccess();
    await prefs.setString(_guardKey(email), jsonEncode(guard.toJson()));
    final user = _toUser(email, data);
    _currentUser = user;
    await _session.save(user.email);
    return user;
  }

  // ---------- US-004 password reset ----------

  /// Always finishes the same way whether or not the email exists (no account leak).
  Future<void> sendPasswordReset(String email) async {
    final prefs = await SharedPreferences.getInstance();
    lastDemoResetToken = null;
    if (await _readUser(prefs, email) == null) return;
    final token =
        base64UrlEncode(List<int>.generate(24, (_) => _random.nextInt(256)));
    await prefs.setString(
      _resetKey(token),
      jsonEncode({
        'email': email.trim().toLowerCase(),
        'expiresAt':
            DateTime.now().add(resetLinkLifetime).millisecondsSinceEpoch,
      }),
    );
    lastDemoResetToken =
        token; // In Firebase mode this token arrives by email instead.
  }

  Future<void> resetPassword(
      {required String token, required String newPassword}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_resetKey(token));
    if (raw == null) {
      throw AuthException('reset-expired', AppStrings.resetExpired);
    }
    final info = jsonDecode(raw) as Map<String, dynamic>;
    await prefs.remove(_resetKey(token)); // a link works once
    final expiresAt =
        DateTime.fromMillisecondsSinceEpoch(info['expiresAt'] as int);
    if (!DateTime.now().isBefore(expiresAt)) {
      throw AuthException('reset-expired', AppStrings.resetExpired);
    }
    final email = info['email'] as String;
    final data = await _readUser(prefs, email);
    if (data == null) {
      throw AuthException('reset-expired', AppStrings.resetExpired);
    }
    final salt = _newSalt();
    data['salt'] = salt;
    data['hash'] = _hash(salt, newPassword);
    await _writeUser(prefs, email, data);
    await prefs.remove(_guardKey(email));
  }

  // ---------- US-005 stay logged in ----------

  /// Called by the splash screen. Returns the user if a session younger than 30 days exists.
  Future<NaapUser?> restoreSession() async {
    final email = await _session.readValidEmail();
    if (email == null) return null;
    final prefs = await SharedPreferences.getInstance();
    final data = await _readUser(prefs, email);
    if (data == null) {
      await _session.clear();
      return null;
    }
    _currentUser = _toUser(email, data);
    return _currentUser;
  }

  // ---------- US-006 log out ----------

  Future<void> logOut() async {
    _currentUser = null;
    await _session.clear();
  }

  // ---------- US-007 email verification ----------

  Future<void> sendVerificationEmail() async {
    // Firebase mode: currentUser.sendEmailVerification(). Local mode has nothing to send.
  }

  /// Local-mode stand-in for tapping the link in the email.
  Future<void> markEmailVerifiedDemo() async {
    final user = _currentUser;
    if (user == null) return;
    final prefs = await SharedPreferences.getInstance();
    final data = await _readUser(prefs, user.email);
    if (data == null) return;
    data['verified'] = true;
    await _writeUser(prefs, user.email, data);
    _currentUser = user.copyWith(emailVerified: true);
  }

  // ---------- US-008 change password ----------

  Future<void> changePassword(
      {required String currentPassword, required String newPassword}) async {
    final user = _currentUser;
    if (user == null) {
      throw AuthException('not-signed-in', AppStrings.logInAgain);
    }
    final prefs = await SharedPreferences.getInstance();
    final data = await _readUser(prefs, user.email);
    if (data == null ||
        !_sameHash(_hash(data['salt'] as String, currentPassword),
            data['hash'] as String)) {
      throw AuthException('wrong-current', AppStrings.wrongCurrentPassword);
    }
    final salt = _newSalt();
    data['salt'] = salt;
    data['hash'] = _hash(salt, newPassword);
    data['passwordChangedAt'] = DateTime.now().millisecondsSinceEpoch;
    await _writeUser(prefs, user.email, data);
    // Firebase mode: other devices are signed out by revoking their refresh tokens.
  }
}
