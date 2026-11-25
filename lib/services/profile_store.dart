import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';
import 'auth_service.dart';

/// Saves the profile from US-011 and US-012 on the phone, one entry per email.
/// Load and save are a single key lookup: O(1).
class ProfileStore {
  ProfileStore._();
  static final ProfileStore instance = ProfileStore._();

  static const String _onboardingKey = 'naap_onboarding_done';

  /// Goes up by one on every save. Screens that show sizes (Home, product
  /// pages) listen to it, so a fit change in Profile updates them (US-013).
  final ValueNotifier<int> revision = ValueNotifier<int>(0);

  String _keyFor(String email) => 'naap_profile_${email.toLowerCase()}';

  Future<UserProfile?> load(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(email));
    if (raw == null) return null;
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(String email, UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFor(email), jsonEncode(profile.toJson()));
    revision.value++;
  }

  /// The signed-in user's profile, or null before setup starts.
  Future<UserProfile?> loadCurrent() =>
      load(AuthService.instance.currentUser?.email ?? '');

  /// Reads the latest saved profile, applies [change] and saves it. Every setup
  /// step uses this, so no step can overwrite a field another step just saved.
  Future<void> updateCurrent(
      UserProfile Function(UserProfile profile) change) async {
    final user = AuthService.instance.currentUser;
    final email = user?.email ?? '';
    final current = await load(email) ?? UserProfile(name: user?.name ?? '');
    await save(email, change(current));
  }

  // US-009: welcome screens are shown only once.
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }
}
