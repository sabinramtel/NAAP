import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'reset_password_screen.dart';

/// US-004: ask for a reset link. The message is the same whether or not the email
/// has an account, so nobody can use this screen to find out who is registered.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool loading = false;
  bool sent = false;

  Future<void> _send() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => loading = true);
    await AuthService.instance.sendPasswordReset(emailController.text);
    if (!mounted) return;
    setState(() {
      loading = false;
      sent = true;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Reset your password',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 6),
                const Text("Enter your email and we'll send you a link.",
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                AppTextField(
                  controller: emailController,
                  label: AppStrings.email,
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 20),
                PrimaryButton(label: AppStrings.sendLink, loading: loading, onPressed: _send),
                if (sent) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(AppStrings.resetSentMessage),
                  ),
                  // Local mode only: stands in for tapping the link in the email.
                  TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ResetPasswordScreen(token: AuthService.instance.lastDemoResetToken ?? ''),
                    )),
                    child: const Text('Open reset link (demo)'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
