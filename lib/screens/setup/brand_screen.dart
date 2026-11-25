import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_flow.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../data/brands.dart';
import '../../services/profile_store.dart';
import '../../widgets/setup_step_scaffold.dart';

/// US-015: choose the brands you buy, with search as you type,
/// a count on the button and a way to ask for a missing brand.
class BrandScreen extends StatefulWidget {
  final bool editing;

  const BrandScreen({super.key, this.editing = false});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  static const String _requestsKey = 'naap_brand_requests';

  final searchController = TextEditingController();
  final Set<String> picked = {};
  List<Brand> shown = Brands.all;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await ProfileStore.instance.loadCurrent();
    if (mounted) setState(() => picked.addAll(p?.brands ?? const []));
  }

  void _search(String text) =>
      setState(() => shown = Brands.search(Brands.all, text));

  Future<void> _requestBrand() async {
    final nameController = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.requestBrand),
        content: TextField(
          controller: nameController,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: AppStrings.brandName),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppStrings.cancel)),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, nameController.text.trim()),
            child: Text(AppStrings.send),
          ),
        ],
      ),
    );
    nameController.dispose();
    if (name == null || name.isEmpty) return;
    // Local mode keeps requests on the phone. With Firebase they go to the team.
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_requestsKey) ?? <String>[];
    await prefs.setStringList(_requestsKey, [...list, name]);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(AppStrings.brandRequested(name))));
  }

  Future<void> _continue() async {
    setState(() => loading = true);
    final ordered = [
      for (final b in Brands.all)
        if (picked.contains(b.id)) b.id
    ];
    await ProfileStore.instance
        .updateCurrent((p) => p.copyWith(brands: ordered));
    if (!mounted) return;
    setState(() => loading = false);
    await AppFlow.finishStep(context, editing: widget.editing);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SetupStepScaffold(
      step: SetupStep.brands,
      editing: widget.editing,
      title: AppStrings.whichBrands,
      help: AppStrings.brandsHelp,
      loading: loading,
      onContinue: _continue,
      buttonLabel: picked.isEmpty
          ? null
          : (widget.editing
              ? AppStrings.save
              : AppStrings.continueWithCount(picked.length)),
      footer: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: _requestBrand,
          icon: const Icon(Icons.add_circle_outline),
          label: Text(AppStrings.cantFindIt),
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: _search,
            decoration: InputDecoration(
              hintText: AppStrings.searchBrands,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.card,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: shown.isEmpty
                ? Center(
                    child: Text(AppStrings.noBrandsMatch,
                        style: const TextStyle(color: AppColors.textSecondary)))
                : ListView.builder(
                    itemCount: shown.length,
                    itemBuilder: (context, i) {
                      final brand = shown[i];
                      return CheckboxListTile(
                        value: picked.contains(brand.id),
                        title: Text(brand.name),
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4),
                        onChanged: (on) => setState(() => on == true
                            ? picked.add(brand.id)
                            : picked.remove(brand.id)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
