import 'package:flutter/material.dart';

import 'constants/app_strings.dart';
import 'models/naap_user.dart';
import 'models/user_profile.dart';
import 'screens/height_screen.dart';
import 'screens/main_shell.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/setup/brand_screen.dart';
import 'screens/setup/fit_screen.dart';
import 'screens/setup/language_screen.dart';
import 'screens/setup/style_screen.dart';
import 'services/auth_service.dart';
import 'services/language_controller.dart';
import 'services/profile_store.dart';

/// The setup steps in order. Sprint 1 had profile and height;
/// Sprint 2 adds language first, then fit, styles and brands.
enum SetupStep { language, profile, height, fit, styles, brands }

/// Decides where a signed-in user lands: the first setup step they haven't
/// done, or the main tabs once setup is finished.
class AppFlow {
  AppFlow._();

  /// One pass over six fields: O(1).
  static SetupStep? firstMissing(UserProfile? p) {
    if (p == null || p.language == null) return SetupStep.language;
    if (p.birthDate == null) return SetupStep.profile;
    if (p.heightCm == null) return SetupStep.height;
    if (p.fit == null) return SetupStep.fit;
    if (p.styles == null) return SetupStep.styles;
    if (p.brands == null) return SetupStep.brands;
    return null;
  }

  static Widget screenFor(SetupStep step) {
    switch (step) {
      case SetupStep.language:
        return const LanguageScreen();
      case SetupStep.profile:
        return const ProfileSetupScreen();
      case SetupStep.height:
        return const HeightScreen();
      case SetupStep.fit:
        return const FitScreen();
      case SetupStep.styles:
        return const StyleScreen();
      case SetupStep.brands:
        return const BrandScreen();
    }
  }

  /// "Step 3 of 6" for the app bar of each setup screen.
  static String stepLabel(SetupStep step) => AppStrings.stepOf(step.index + 1, SetupStep.values.length);

  static Future<Widget> screenAfterLogin(NaapUser user) async {
    final profile = await ProfileStore.instance.load(user.email);
    // US-016: a user's saved language follows them to this phone.
    final saved = profile?.language;
    if (saved != null) await LanguageController.instance.change(LanguageController.fromCode(saved));
    final step = firstMissing(profile);
    return step == null ? const MainShell() : screenFor(step);
  }

  /// Called by each setup screen after it saves. Opens the next missing step,
  /// or the main tabs when every step is done.
  static Future<void> next(BuildContext context) async {
    final email = AuthService.instance.currentUser?.email ?? '';
    final profile = await ProfileStore.instance.load(email);
    if (!context.mounted) return;
    final step = firstMissing(profile);
    if (step == null) {
      goAndClear(context, const MainShell());
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screenFor(step)));
    }
  }

  /// End of every setup screen: opened from Profile it goes back, during
  /// setup it moves to the next step.
  static Future<void> finishStep(BuildContext context, {required bool editing}) async {
    if (editing) {
      Navigator.of(context).pop(true);
    } else {
      await next(context);
    }
  }

  /// Opens [next] and clears every earlier screen, so Back can't return to log in.
  static void goAndClear(BuildContext context, Widget next) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => next),
      (route) => false,
    );
  }
}
