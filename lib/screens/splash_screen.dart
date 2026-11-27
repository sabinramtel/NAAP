import 'package:flutter/material.dart';

import '../app_flow.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/auth_service.dart';
import '../services/profile_store.dart';
import '../widgets/naap_logo.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

/// US-010: animated logo while the app starts (under 3 seconds), then
/// US-005: goes straight to the account if a session is still valid.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
  bool started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (started) return;
    started = true;
    // Respect the phone's "remove animations" setting.
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) {
      controller.value = 1;
    } else {
      controller.forward();
    }
    _openNextScreen(reduceMotion);
  }

  /// Loads the session while the logo plays, so the wait is never longer than the animation.
  Future<void> _openNextScreen(bool reduceMotion) async {
    final minimumShow = Future.delayed(Duration(milliseconds: reduceMotion ? 500 : 2300));
    Widget next;
    final user = await AuthService.instance.restoreSession();
    if (user != null) {
      next = await AppFlow.screenAfterLogin(user);
    } else if (await ProfileStore.instance.hasSeenOnboarding()) {
      next = const LoginScreen();
    } else {
      next = const OnboardingScreen();
    }
    await minimumShow;
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => next,
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final t = controller.value;
            final wordOpacity = ((t - 0.7) / 0.3).clamp(0.0, 1.0);
            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NaapLogo(size: 112, progress: t),
                      const SizedBox(height: 20),
                      Opacity(
                        opacity: wordOpacity,
                        child: Transform.translate(
                          offset: Offset(0, 12 * (1 - wordOpacity)),
                          child: Column(
                            children: [
                              Text(AppStrings.appName,
                                  style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                      color: AppColors.navy)),
                              SizedBox(height: 4),
                              Text('${AppStrings.appNameNepali} · ${AppStrings.measure}',
                                  style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 32,
                  child: Opacity(
                    opacity: (t / 0.6).clamp(0.0, 1.0),
                    child: Text(AppStrings.fromTeam,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
