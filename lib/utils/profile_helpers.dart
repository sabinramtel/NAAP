import '../constants/app_strings.dart';

/// Small helpers for the profile screens (US-011). All O(1) or O(n) in name length.
class ProfileHelpers {
  ProfileHelpers._();

  static const int minimumAge = 18;

  /// Age in full years on [today].
  static int ageOn(DateTime birthDate, DateTime today) {
    var age = today.year - birthDate.year;
    final hadBirthdayThisYear = today.month > birthDate.month ||
        (today.month == birthDate.month && today.day >= birthDate.day);
    if (!hadBirthdayThisYear) age--;
    return age;
  }

  static bool isOldEnough(DateTime birthDate, DateTime today) =>
      ageOn(birthDate, today) >= minimumAge;

  /// "Aanya Sharma" -> "AS", "aarohi" -> "A". Used when no photo is chosen.
  static String initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  static String formatDate(DateTime d) {
    return '${d.day} ${AppStrings.monthNames[d.month - 1]} ${d.year}';
  }
}
