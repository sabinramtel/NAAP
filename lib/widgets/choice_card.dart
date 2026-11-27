import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// A tappable option card with a radio mark, for single-choice setup steps
/// (language in US-016, fit in US-013). Selected cards get a blue border.
class ChoiceCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final Widget? leading;
  final VoidCallback onTap;

  const ChoiceCard({
    super.key,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? AppColors.blueSoft : AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? AppColors.blue : AppColors.border, width: selected ? 2 : 1),
          ),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 14)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: selected ? AppColors.blue : AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
