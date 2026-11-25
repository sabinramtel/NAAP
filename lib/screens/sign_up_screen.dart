import 'package:flutter/material.dart';

import '../app_flow.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_strings.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';
import 'login_screen.dart';

/// US-001 (email sign-up) and US-002 (Google button).
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool loading = false;
  bool emailTaken = false;

  Future<void> _createAccount() async {
    setState(() => emailTaken = false);
    if (!formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      final user = await AuthService.instance.signUp(
        name: nameController.text,
        email: emailController.text,
        password: passController.text,
      );
      final next = await AppFlow.screenAfterLogin(
          user); // Sprint 2: setup starts with language
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppStrings.verificationSent)));
      AppFlow.goAndClear(context, next);
    } on AuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'email-taken') {
        setState(() => emailTaken = true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.createYourAccount,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy)),
                const SizedBox(height: 6),
                Text(AppStrings.measurementsPrivate,
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                SocialButton(
                    label: AppStrings.continueWithGoogle,
                    image: googleImage,
                    onPressed: _google),
                const SizedBox(height: 18),
                Row(children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(AppStrings.orWithEmail,
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  Expanded(child: Divider()),
                ]),
                const SizedBox(height: 18),
                AppTextField(
                  controller: nameController,
                  label: AppStrings.fullName,
                  icon: Icons.person_outline,
                  validator: Validators.name,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: emailController,
                  label: AppStrings.email,
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  onChanged: (_) {
                    if (emailTaken) setState(() => emailTaken = false);
                  },
                ),
                if (emailTaken)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(AppStrings.emailTaken,
                              style: TextStyle(color: AppColors.error)),
                        ),
                        TextButton(
                            onPressed: _goToLogin,
                            child: Text(AppStrings.goToLogin)),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: passController,
                  label: AppStrings.password,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  helperText: AppStrings.passwordRule,
                  validator: Validators.password,
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                    label: AppStrings.createAccount,
                    loading: loading,
                    onPressed: _createAccount),
                const SizedBox(height: 8),
                Center(
                    child: TextButton(
                        onPressed: _goToLogin,
                        child: Text(AppStrings.haveAccount))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
