import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../services/profile_store.dart';
import '../widgets/slide_deck.dart';
import 'sign_up_screen.dart';

/// US-009: three welcome screens, shown only the first time.
/// The slide layout is shared with the Home guide (widgets/slide_deck.dart).
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const List<IconData> icons = [
    Icons.camera_alt_outlined,
    Icons.accessibility_new,
    Icons.checkroom_outlined,
  ];

  Future<void> _finish(BuildContext context) async {
    await ProfileStore.instance.markOnboardingSeen();
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final titles = AppStrings.onboardingTitles;
    final bodies = AppStrings.onboardingBodies;
    return Scaffold(
      body: SlideDeck(
        slides: [for (var i = 0; i < icons.length; i++) Slide(icon: icons[i], title: titles[i], body: bodies[i])],
        doneLabel: AppStrings.getStarted,
        onDone: () => _finish(context),
      ),
    );
  }
}
