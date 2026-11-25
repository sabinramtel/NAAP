import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/profile_helpers.dart';

/// The round profile picture used on profile setup and the Profile tab:
/// the chosen photo, or the user's initials when there is none (US-011).
class ProfileAvatar extends StatelessWidget {
  final String name;
  final String? photoPath;
  final double radius;

  const ProfileAvatar(
      {super.key,
      required this.name,
      required this.photoPath,
      required this.radius});

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    final hasPhoto = path != null && File(path).existsSync();
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.blueSoft,
      backgroundImage: hasPhoto ? FileImage(File(path)) : null,
      child: hasPhoto
          ? null
          : Text(
              ProfileHelpers.initials(name),
              style: TextStyle(
                  fontSize: radius * 0.6,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue),
            ),
    );
  }
}
