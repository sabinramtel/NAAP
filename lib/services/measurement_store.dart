import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/measurements.dart';

/// Saves the latest measurements per account (US-017). One key per email: O(1).
class MeasurementStore {
  MeasurementStore._();
  static final MeasurementStore instance = MeasurementStore._();

  /// Goes up on every save so Home can refresh its size card.
  final ValueNotifier<int> revision = ValueNotifier<int>(0);

  String _keyFor(String email) => 'naap_measurements_${email.toLowerCase()}';

  Future<Measurements?> load(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(email));
    if (raw == null) return null;
    return Measurements.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(String email, Measurements m) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFor(email), jsonEncode(m.toJson()));
    revision.value++;
  }
}
