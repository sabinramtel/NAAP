import 'package:flutter/material.dart';

import 'models/naap_user.dart';
import 'screens/profile_setup_screen.dart';
import 'services/profile_store.dart';

/// Decides where a signed-in user lands: profile setup until it's finished, then ProfileSetupScreen.
class AppFlow {
  AppFlow._();

  static Future<Widget> screenAfterLogin(NaapUser user) async {
    final profile = await ProfileStore.instance.load(user.email);
    if (profile == null || !profile.isComplete) return const ProfileSetupScreen();
    return const ProfileSetupScreen();
  }

  /// Opens [next] and clears every earlier screen, so Back can't return to log in.
  static void goAndClear(BuildContext context, Widget next) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => next),
      (route) => false,
    );
  }
}
