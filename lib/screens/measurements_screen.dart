import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/measurements.dart';
import '../utils/profile_helpers.dart';

/// US-017: every saved measurement. Numbers stay in cm in both languages.
class MeasurementsScreen extends StatelessWidget {
  final Measurements measurements;

  const MeasurementsScreen({super.key, required this.measurements});

  @override
  Widget build(BuildContext context) {
    final m = measurements;
    final rows = <(String, double)>[
      (AppStrings.chest, m.chest),
      (AppStrings.waist, m.waist),
      (AppStrings.hip, m.hip),
      (AppStrings.shoulder, m.shoulder),
      (AppStrings.inseam, m.inseam),
      (AppStrings.sleeve, m.sleeve),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.measurements)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          if (m.isSample)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(AppStrings.sampleNote,
                  style: const TextStyle(color: AppColors.textSecondary)),
            ),
          Card(
            elevation: 0,
            color: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.border),
            ),
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  ListTile(
                    title: Text(rows[i].$1),
                    trailing: Text('${rows[i].$2.toStringAsFixed(1)} cm',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(AppStrings.measuredOn(ProfileHelpers.formatDate(m.takenAt)),
              style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
