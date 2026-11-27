import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'screens/splash_screen.dart';
import 'services/language_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // US-016: open in the language chosen last time.
  await LanguageController.instance.load();
  runApp(const NaapApp());
}

class NaapApp extends StatelessWidget {
  const NaapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NAAP',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue, primary: AppColors.blue),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.navy,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      ),
      home: const SplashScreen(),
    );
  }
}
