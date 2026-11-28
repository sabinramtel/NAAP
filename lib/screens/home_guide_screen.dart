import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_strings.dart';
import '../services/auth_service.dart';
import '../widgets/slide_deck.dart';

/// US-027: three slides the first time a user reaches Home, showing where
/// Body scan, Try-On and Size guide are. Finishing or skipping marks it seen
/// for that account. Help and feedback can show it again.
class HomeGuideScreen extends StatelessWidget {
  const HomeGuideScreen({super.key});

  static String _key() => 'naap_home_guide_seen_${AuthService.instance.currentUser?.email.toLowerCase() ?? ''}';

  /// Called by the main tabs once they are on screen.
  static Future<void> showIfFirstTime(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_key()) ?? false) return;
    if (!context.mounted) return;
    await show(context);
  }

  static Future<void> show(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: (_) => const HomeGuideScreen()));

  Future<void> _done(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(), true);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const icons = [Icons.accessibility_new, Icons.checkroom, Icons.straighten];
    final titles = AppStrings.guideTitles;
    final bodies = AppStrings.guideBodies;
    return Scaffold(
      body: SlideDeck(
        slides: [for (var i = 0; i < icons.length; i++) Slide(icon: icons[i], title: titles[i], body: bodies[i])],
        doneLabel: AppStrings.gotIt,
        onDone: () => _done(context),
      ),
    );
  }
}
