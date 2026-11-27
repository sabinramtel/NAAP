import '../constants/app_strings.dart';

/// Input checks used by the sign-up, log-in and profile forms.
/// Each check walks the text once: O(n) time, O(1) extra space.
class Validators {
  Validators._();

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  /// Returns an error message, or null when the email looks valid.
  static String? email(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return AppStrings.enterEmail;
    if (!_emailPattern.hasMatch(text)) return AppStrings.invalidEmail;
    return null;
  }

  /// US-001: at least 8 characters and at least one number.
  /// One pass over the characters, stops early once a digit is found.
  static String? password(String? value) {
    final text = value ?? '';
    if (text.length < 8) return AppStrings.passwordTooShort;
    if (!hasDigit(text)) return AppStrings.passwordNeedsNumber;
    return null;
  }

  static bool hasDigit(String text) {
    for (var i = 0; i < text.length; i++) {
      final c = text.codeUnitAt(i);
      if (c >= 48 && c <= 57) return true; // '0'..'9'
    }
    return false;
  }

  static String? name(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return AppStrings.enterName;
    if (text.length < 2) return AppStrings.nameTooShort;
    return null;
  }

  static String? notEmpty(String? value, String message) {
    if ((value ?? '').isEmpty) return message;
    return null;
  }
}
