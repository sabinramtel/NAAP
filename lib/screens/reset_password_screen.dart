import 'package:flutter/material.dart';

import '../app_flow.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';

/// US-004: the page the reset link opens. Links last 30 minutes and work once.
class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final newController = TextEditingController();
  final confirmController = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> _save() async {
    setState(() => error = null);
    if (!formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      await AuthService.instance.resetPassword(token: widget.token, newPassword: newController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed. Log in with your new password.')));
      AppFlow.goAndClear(context, const LoginScreen());
    } on AuthException catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    newController.dispose();
    confirmController.dispose();
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
                const Text('Choose a new password',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 24),
                AppTextField(
                  controller: newController,
                  label: AppStrings.newPassword,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  helperText: AppStrings.passwordRule,
                  validator: Validators.password,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: confirmController,
                  label: AppStrings.confirmPassword,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (v) => v == newController.text ? null : AppStrings.passwordsDontMatch,
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(error!, style: const TextStyle(color: AppColors.error)),
                  ),
                const SizedBox(height: 24),
                PrimaryButton(label: AppStrings.save, loading: loading, onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
