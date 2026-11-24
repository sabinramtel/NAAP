import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

/// Saves the profile from US-011 and US-012 on the phone, one entry per email.
/// Load and save are a single key lookup: O(1).
class ProfileStore {
  ProfileStore._();
  static final ProfileStore instance = ProfileStore._();

  static const String _onboardingKey = 'naap_onboarding_done';

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
