import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/home_repository.dart';
import '../utils/size_recommender.dart';
import '../utils/fit_labels.dart';

/// US-017: the user's sizes for tops, jeans and dresses. Tapping it opens
/// every measurement. Size labels (S, M, 32) are the same in both languages.
class SizeProfileCard extends StatelessWidget {
  final HomeData data;
  final VoidCallback onTap;

  const SizeProfileCard({super.key, required this.data, required this.onTap});

  Widget _size(String label, String? size) {
    return Expanded(
      child: Column(
        children: [
          Text(size ?? '-',
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sample = data.measurements?.isSample ?? false;
    return Semantics(
      button: true,
      label: AppStrings.seeAllMeasurements,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient:
                const LinearGradient(colors: [AppColors.navy, AppColors.blue]),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(AppStrings.yourSizes,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(AppStrings.fitLabel(data.fit.label),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _size(AppStrings.tops, data.sizeFor(Garment.top)),
                  _size(AppStrings.jeans, data.sizeFor(Garment.jeans)),
                  _size(AppStrings.dresses, data.sizeFor(Garment.dress)),
                ],
              ),
              const SizedBox(height: 14),
              if (sample)
                Text(AppStrings.sampleNote,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(AppStrings.seeAllMeasurements,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
