import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// US-005: keeps the user logged in for 30 days.
/// The session lives in encrypted phone storage (Android Keystore), not plain prefs.
/// Reading it is one key lookup plus one date comparison: O(1).
class SessionStore {
  static const Duration sessionLength = Duration(days: 30);
  static const String _key = 'naap_session';

  final FlutterSecureStorage _storage;

  SessionStore({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  Future<void> save(String email, {DateTime? now}) async {
    final start = now ?? DateTime.now();
    final data = {
      'email': email,
      'expiresAt': start.add(sessionLength).millisecondsSinceEpoch,
    };
    await _storage.write(key: _key, value: jsonEncode(data));
  }

  /// The email of the saved session, or null when there is none or it has expired.
  Future<String?> readValidEmail({DateTime? now}) async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(data['expiresAt'] as int);
    if (!(now ?? DateTime.now()).isBefore(expiresAt)) {
      await clear();
      return null;
    }
    return data['email'] as String?;
  }

  Future<void> clear() => _storage.delete(key: _key);
}
