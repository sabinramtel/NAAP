import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import 'primary_button.dart';

/// US-006: asks before logging out. After logging out, every earlier screen is
/// removed from the stack, so the phone's back button can't return to the account.
Future<void> showLogoutSheet(BuildContext context) async {
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.logOutQuestion,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 6),
          Text(AppStrings.logOutBody, style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: AppStrings.cancel,
                  outlined: true,
                  onPressed: () => Navigator.pop(sheetContext, false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: AppStrings.logOut,
                  onPressed: () => Navigator.pop(sheetContext, true),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  if (confirmed != true) return;
  await AuthService.instance.logOut();
  if (!context.mounted) return;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
  );
}
