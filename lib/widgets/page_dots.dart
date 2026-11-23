import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Dots under the welcome screens (US-009). The current one stretches into a pill.
class PageDots extends StatelessWidget {
  final int count;
  final int current;

  const PageDots({super.key, required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page ${current + 1} of $count',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (i) {
          final active = i == current;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: active ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? AppColors.blue : AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}
