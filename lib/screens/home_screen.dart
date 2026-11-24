import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/profile_store.dart';
import '../utils/profile_helpers.dart';
import '../utils/unit_converter.dart';
import '../widgets/logout_sheet.dart';
import '../widgets/verify_email_banner.dart';
import 'change_password_screen.dart';
import 'height_screen.dart';
import 'profile_setup_screen.dart';

/// Sprint 1 Home. It only holds the account pieces built this week
/// (verify banner, profile, height, password, log out). The real Home with
/// scan, avatar and shop arrives in Sprint 2 (US-017).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProfile? profile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final email = AuthService.instance.currentUser?.email;
    if (email == null) return;
    final p = await ProfileStore.instance.load(email);
    if (mounted) setState(() => profile = p);
  }

  /// Opens an edit screen and reloads the profile when it comes back saved.
  Future<void> _open(Widget screen) async {
    final changed = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => screen));
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final name = profile?.name.isNotEmpty == true ? profile!.name : (user?.name ?? '');
    final photo = profile?.photoPath;
    final hasPhoto = photo != null && File(photo).existsSync();
    final height = profile?.heightCm;
    final heightText = height == null
        ? 'Not set'
        : (profile!.prefersImperial ? UnitConverter.formatFeetInches(height) : UnitConverter.formatCm(height));

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.blueSoft,
                  backgroundImage: hasPhoto ? FileImage(File(photo!)) : null,
                  child: hasPhoto
                      ? null
                      : Text(ProfileHelpers.initials(name),
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.blue)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi, ${name.split(' ').first}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy)),
                      Text(user?.email ?? '', style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (user != null && !user.emailVerified) ...[
              VerifyEmailBanner(onVerified: () => setState(() {})),
              const SizedBox(height: 16),
            ],
            Card(
              elevation: 0,
              color: AppColors.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Edit profile'),
                    subtitle: Text(profile?.birthDate == null
                        ? 'Date of birth not set'
                        : 'Born ${ProfileHelpers.formatDate(profile!.birthDate!)}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _open(const ProfileSetupScreen(editing: true)),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.height),
                    title: const Text('Height'),
                    subtitle: Text(heightText),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _open(const HeightScreen(editing: true)),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text(AppStrings.changePassword),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _open(const ChangePasswordScreen()),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.error),
                    title: const Text(AppStrings.logOut, style: TextStyle(color: AppColors.error)),
                    onTap: () => showLogoutSheet(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blueSoft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Scanning, your avatar and the shop come in the next sprints. '
                'This page only holds what Sprint 1 built.',
                style: TextStyle(color: AppColors.navy, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
