import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';

/// US-018: Explore, Try-On and Saved are built in later sprints. Each tab still
/// exists, scrolls, and has its own controller so "tap again to go to the top" works.
class ComingSoonTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final ScrollController scrollController;

  const ComingSoonTab(
      {super.key,
      required this.title,
      required this.icon,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 80),
          Icon(icon, size: 72, color: AppColors.blue),
          const SizedBox(height: 16),
          Text(AppStrings.comingSoon,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
