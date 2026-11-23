import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/auth_service.dart';

/// US-007: reminds the user to verify their email, with a Resend button that
/// waits 60 seconds between sends. One Timer ticking once a second: O(1).
class VerifyEmailBanner extends StatefulWidget {
  final VoidCallback onVerified;

  const VerifyEmailBanner({super.key, required this.onVerified});

  @override
  State<VerifyEmailBanner> createState() => _VerifyEmailBannerState();
}

class _VerifyEmailBannerState extends State<VerifyEmailBanner> {
  static const int cooldownSeconds = 60;
  int secondsLeft = 0;
  Timer? timer;

  Future<void> _resend() async {
    await AuthService.instance.sendVerificationEmail();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.verificationSent)));
    setState(() => secondsLeft = cooldownSeconds);
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => secondsLeft--);
      if (secondsLeft <= 0) t.cancel();
    });
  }

  Future<void> _demoVerify() async {
    await AuthService.instance.markEmailVerifiedDemo();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.emailVerified)));
    widget.onVerified();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.tape.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.tape.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.mark_email_unread_outlined, color: AppColors.navy),
              SizedBox(width: 10),
              Expanded(child: Text(AppStrings.verifyBanner, style: TextStyle(fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              TextButton(
                onPressed: secondsLeft > 0 ? null : _resend,
                child: Text(secondsLeft > 0 ? 'Resend in ${secondsLeft}s' : AppStrings.resendEmail),
              ),
              // Local mode only: stands in for tapping the link in the email.
              TextButton(onPressed: _demoVerify, child: const Text('Mark verified (demo)')),
            ],
          ),
        ],
      ),
    );
  }
}
