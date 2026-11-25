import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../data/style_options.dart';
import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../../services/language_controller.dart';
import '../../services/profile_store.dart';
import '../../utils/profile_helpers.dart';
import '../../utils/size_recommender.dart';
import '../../utils/fit_labels.dart';
import '../../utils/unit_converter.dart';
import '../../widgets/logout_sheet.dart';
import '../../widgets/profile_avatar.dart';
import '../../widgets/verify_email_banner.dart';
import '../change_password_screen.dart';
import '../height_screen.dart';
import '../profile_setup_screen.dart';
import '../setup/brand_screen.dart';
import '../setup/fit_screen.dart';
import '../setup/language_screen.dart';
import '../setup/style_screen.dart';

/// US-018: the Profile tab. It holds the Sprint 1 account pieces (they were on
/// the old Home), plus Preferences where the user changes fit (US-013),
/// styles (US-014), brands (US-015) and language (US-016).
class ProfileTab extends StatefulWidget {
  final ScrollController scrollController;

  const ProfileTab({super.key, required this.scrollController});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  UserProfile? profile;

  @override
  void initState() {
    super.initState();
    ProfileStore.instance.revision.addListener(_load);
    _load();
  }

  Future<void> _load() async {
    final email = AuthService.instance.currentUser?.email;
    if (email == null) return;
    final p = await ProfileStore.instance.load(email);
    if (mounted) setState(() => profile = p);
  }

  @override
  void dispose() {
    ProfileStore.instance.revision.removeListener(_load);
    super.dispose();
  }

  void _open(Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  Widget _card(List<Widget> tiles) {
    return Card(
      elevation: 0,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            tiles[i]
          ],
        ],
      ),
    );
  }

  Widget _tile(
          IconData icon, String title, String? subtitle, VoidCallback onTap) =>
      ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subtitle == null
            ? null
            : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      );

  Widget _heading(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppColors.navy)),
      );

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final p = profile;
    final name = (p?.name.isNotEmpty ?? false) ? p!.name : (user?.name ?? '');
    final height = p?.heightCm;
    final heightText = height == null
        ? AppStrings.notSet
        : (p!.prefersImperial
            ? UnitConverter.formatFeetInches(height)
            : UnitConverter.formatCm(height));
    final styles = p?.styles ?? const <String>[];
    final brands = p?.brands ?? const <String>[];

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.tabProfile)),
      body: ListView(
        controller: widget.scrollController,
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Row(
            children: [
              ProfileAvatar(name: name, photoPath: p?.photoPath, radius: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy)),
                    Text(user?.email ?? '',
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          if (user != null && !user.emailVerified) ...[
            const SizedBox(height: 16),
            VerifyEmailBanner(onVerified: () => setState(() {})),
          ],
          _heading(AppStrings.account),
          _card([
            _tile(
              Icons.person_outline,
              AppStrings.editProfile,
              p?.birthDate == null
                  ? AppStrings.dateNotSet
                  : AppStrings.bornOn(ProfileHelpers.formatDate(p!.birthDate!)),
              () => _open(const ProfileSetupScreen(editing: true)),
            ),
            _tile(Icons.height, AppStrings.height, heightText,
                () => _open(const HeightScreen(editing: true))),
            _tile(Icons.lock_outline, AppStrings.changePassword, null,
                () => _open(const ChangePasswordScreen())),
          ]),
          _heading(AppStrings.preferences),
          _card([
            _tile(
                Icons.straighten,
                AppStrings.fit,
                FitPreferenceCode.fromCode(p?.fit).label,
                () => _open(const FitScreen(editing: true))),
            _tile(
              Icons.style_outlined,
              AppStrings.styles,
              styles.isEmpty
                  ? AppStrings.noneChosen
                  : styles.map(StyleOptions.labelFor).join(', '),
              () => _open(const StyleScreen(editing: true)),
            ),
            _tile(
                Icons.local_offer_outlined,
                AppStrings.brands,
                brands.isEmpty ? AppStrings.noneChosen : '${brands.length}',
                () => _open(const BrandScreen(editing: true))),
            _tile(
                Icons.translate,
                AppStrings.language,
                LanguageController.instance.isNepali
                    ? AppStrings.nepali
                    : AppStrings.english,
                () => _open(const LanguageScreen(editing: true))),
          ]),
          const SizedBox(height: 16),
          _card([
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: Text(AppStrings.logOut,
                  style: const TextStyle(color: AppColors.error)),
              onTap: () => showLogoutSheet(context),
            ),
          ]),
          const SizedBox(height: 16),
          Text(AppStrings.sprintNote,
              style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
