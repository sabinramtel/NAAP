import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../data/brands.dart';
import '../services/auth_service.dart';
import '../services/profile_store.dart';

/// US-015 (and the Size guide shortcut, US-019): brand size notes with the
/// user's own brands listed first.
class SizeGuideScreen extends StatefulWidget {
  const SizeGuideScreen({super.key});

  @override
  State<SizeGuideScreen> createState() => _SizeGuideScreenState();
}

class _SizeGuideScreenState extends State<SizeGuideScreen> {
  Set<String> selected = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await ProfileStore.instance
        .load(AuthService.instance.currentUser?.email ?? '');
    if (mounted) setState(() => selected = {...?p?.brands});
  }

  String _runs(Brand b) {
    if (b.offsetCm > 0) return AppStrings.runsSmall;
    if (b.offsetCm < 0) return AppStrings.runsLarge;
    return AppStrings.trueToSize;
  }

  Widget _section(String title, List<Brand> brands) {
    if (brands.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
          child: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.navy)),
        ),
        for (final b in brands)
          ListTile(
            title: Text(b.name),
            trailing: Text(_runs(b),
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final split = Brands.splitForUser(Brands.all, selected);
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.sizeGuide)),
      body: ListView(
        children: [
          _section(AppStrings.yourBrands, split.mine),
          _section(
              split.mine.isEmpty ? AppStrings.brands : AppStrings.otherBrands,
              split.others),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
