import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Full-width button. Shows a spinner and ignores taps while [loading] is true,
/// so a slow network can't create two accounts from a double tap.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
        : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: const BorderSide(color: AppColors.border),
                shape: shape,
              ),
              onPressed: loading ? null : onPressed,
              child: child,
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.5),
                shape: shape,
              ),
              onPressed: loading ? null : onPressed,
              child: child,
            ),
    );
  }
}
