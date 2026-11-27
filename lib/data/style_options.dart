import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

/// US-014: the styles a user can pick. Products in the catalogue are tagged
/// with these same ids, so "Picked for you" can match them.
class StyleOption {
  final String id;
  final IconData icon;
  final String Function() label; // a function so it follows the current language

  const StyleOption(this.id, this.icon, this.label);
}

class StyleOptions {
  StyleOptions._();

  static final List<StyleOption> all = [
    StyleOption('casual', Icons.weekend_outlined, () => AppStrings.styleCasual),
    StyleOption('formal', Icons.work_outline, () => AppStrings.styleFormal),
    StyleOption('ethnic', Icons.auto_awesome_outlined, () => AppStrings.styleEthnic),
    StyleOption('sporty', Icons.directions_run, () => AppStrings.styleSporty),
    StyleOption('street', Icons.skateboarding, () => AppStrings.styleStreet),
    StyleOption('minimal', Icons.crop_square, () => AppStrings.styleMinimal),
  ];

  static String labelFor(String id) {
    for (final s in all) {
      if (s.id == id) return s.label();
    }
    return id;
  }
}
