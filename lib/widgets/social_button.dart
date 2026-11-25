import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// "Continue with Google" button, same idea as SocialMediaCard in the class project.
class SocialButton extends StatelessWidget {
  final String label;
  final String image;
  final VoidCallback onPressed;

  const SocialButton(
      {super.key,
      required this.label,
      required this.image,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          backgroundColor: AppColors.card,
          side: const BorderSide(color: AppColors.border),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 22, height: 22),
            const SizedBox(width: 10),
            Text(label,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
