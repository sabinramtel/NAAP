import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

/// US-017: shown on Home instead of the size card until the user has measurements.
class StartScanCard extends StatelessWidget {
  final VoidCallback onStart;

  const StartScanCard({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
                color: AppColors.blueSoft, shape: BoxShape.circle),
            child: const Icon(Icons.accessibility_new,
                color: AppColors.blue, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.noScanTitle,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy)),
                const SizedBox(height: 4),
                Text(AppStrings.noScanBody,
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                FilledButton(
                    onPressed: onStart, child: Text(AppStrings.startBodyScan)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
