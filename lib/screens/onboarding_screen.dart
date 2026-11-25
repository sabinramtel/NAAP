import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/profile_store.dart';
import '../widgets/page_dots.dart';
import '../widgets/primary_button.dart';
import 'sign_up_screen.dart';

/// US-009: three welcome screens, shown only the first time.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int page = 0;

  static const List<IconData> icons = [
    Icons.camera_alt_outlined,
    Icons.accessibility_new,
    Icons.checkroom_outlined,
  ];

  int get pageCount => AppStrings.onboardingTitles.length;

  Future<void> _finish() async {
    await ProfileStore.instance.markOnboardingSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignUpScreen()));
  }

  void _next() {
    if (page == pageCount - 1) {
      _finish();
    } else {
      controller.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final last = page == pageCount - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child:
                  TextButton(onPressed: _finish, child: Text(AppStrings.skip)),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: pageCount,
                onPageChanged: (i) => setState(() => page = i),
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: const BoxDecoration(
                              color: AppColors.blueSoft,
                              shape: BoxShape.circle),
                          child:
                              Icon(icons[i], size: 84, color: AppColors.blue),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Text(AppStrings.onboardingTitles[i],
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                              height: 1.15)),
                      const SizedBox(height: 12),
                      Text(AppStrings.onboardingBodies[i],
                          style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              height: 1.5)),
                    ],
                  ),
                ),
              ),
            ),
            PageDots(count: pageCount, current: page),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: PrimaryButton(
                  label: last ? AppStrings.getStarted : AppStrings.next,
                  onPressed: _next),
            ),
          ],
        ),
      ),
    );
  }
}
