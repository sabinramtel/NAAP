import 'package:flutter/material.dart';

import '../../app_flow.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../data/style_options.dart';
import '../../services/profile_store.dart';
import '../../widgets/setup_step_scaffold.dart';

/// US-014: pick any number of styles, including none. Selected ids live in a
/// Set, so toggling and checking a chip are O(1).
class StyleScreen extends StatefulWidget {
  final bool editing;

  const StyleScreen({super.key, this.editing = false});

  @override
  State<StyleScreen> createState() => _StyleScreenState();
}

class _StyleScreenState extends State<StyleScreen> {
  final Set<String> picked = {};
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await ProfileStore.instance.loadCurrent();
    if (mounted) setState(() => picked.addAll(p?.styles ?? const []));
  }

  void _toggle(String id) {
    setState(() {
      if (!picked.remove(id)) picked.add(id);
    });
  }

  Future<void> _continue() async {
    setState(() => loading = true);
    // Keep the order of the options list, so the saved list is stable.
    final ordered = [for (final s in StyleOptions.all) if (picked.contains(s.id)) s.id];
    await ProfileStore.instance.updateCurrent((p) => p.copyWith(styles: ordered));
    if (!mounted) return;
    setState(() => loading = false);
    await AppFlow.finishStep(context, editing: widget.editing);
  }

  @override
  Widget build(BuildContext context) {
    return SetupStepScaffold(
      step: SetupStep.styles,
      editing: widget.editing,
      title: AppStrings.whatDoYouWear,
      help: AppStrings.stylesHelp,
      loading: loading,
      onContinue: _continue,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final style in StyleOptions.all)
              FilterChip(
                avatar: picked.contains(style.id) ? null : Icon(style.icon, size: 18, color: AppColors.navy),
                label: Text(style.label()),
                selected: picked.contains(style.id),
                showCheckmark: true, // AC: a tick shows when selected
                onSelected: (_) => _toggle(style.id),
                selectedColor: AppColors.blueSoft,
                checkmarkColor: AppColors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
          ],
        ),
      ),
    );
  }
}
