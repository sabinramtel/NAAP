import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

/// US-008: change password from inside the app. The current password is asked first.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> _save() async {
    setState(() => error = null);
    if (!formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      await AuthService.instance.changePassword(
        currentPassword: currentController.text,
        newPassword: newController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.passwordChanged)));
      Navigator.of(context).pop();
    } on AuthException catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.changePassword)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: currentController,
                  label: AppStrings.currentPassword,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (v) => Validators.notEmpty(v, AppStrings.enterCurrentPassword),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: newController,
                  label: AppStrings.newPassword,
                  icon: Icons.lock_reset,
                  isPassword: true,
                  helperText: AppStrings.passwordRule,
                  validator: (v) {
                    final rule = Validators.password(v);
                    if (rule != null) return rule;
                    if (v == currentController.text) return AppStrings.differentPassword;
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: confirmController,
                  label: AppStrings.confirmPassword,
                  icon: Icons.lock_reset,
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
