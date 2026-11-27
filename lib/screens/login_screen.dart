import 'package:flutter/material.dart';

import '../app_flow.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_strings.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/naap_logo.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';

/// US-003: log in with email and password. Wrong details show one general message,
/// and 5 wrong tries in a row pause logins for 5 minutes (see LoginGuard).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> _logIn() async {
    setState(() => error = null);
    if (!formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      final user = await AuthService.instance.logIn(
        email: emailController.text,
        password: passController.text,
      );
      final next = await AppFlow.screenAfterLogin(user);
      if (!mounted) return;
      AppFlow.goAndClear(context, next);
    } on AuthException catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _google() async {
    try {
      final user = await AuthService.instance.signInWithGoogle();
      final next = await AppFlow.screenAfterLogin(user);
      if (!mounted) return;
      AppFlow.goAndClear(context, next);
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: NaapLogo(size: 64)),
                const SizedBox(height: 20),
                Text(AppStrings.welcomeBack,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 6),
                Text(AppStrings.logInToSee,
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 28),
                AppTextField(
                  controller: emailController,
                  label: AppStrings.email,
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: passController,
                  label: AppStrings.password,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (v) => Validators.notEmpty(v, AppStrings.enterPassword),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 4),
                    child: Text(error!, style: const TextStyle(color: AppColors.error)),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                    child: Text(AppStrings.forgotPassword),
                  ),
                ),
                const SizedBox(height: 8),
                PrimaryButton(label: AppStrings.logIn, loading: loading, onPressed: _logIn),
                const SizedBox(height: 14),
                SocialButton(label: AppStrings.continueWithGoogle, image: googleImage, onPressed: _google),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (_) => const SignUpScreen())),
                  child: Text(AppStrings.noAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
