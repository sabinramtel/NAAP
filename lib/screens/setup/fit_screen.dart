import 'package:flutter/material.dart';

import '../../app_flow.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../services/profile_store.dart';
import '../../utils/size_recommender.dart';
import '../../utils/fit_labels.dart';
import '../../widgets/choice_card.dart';
import '../../widgets/setup_step_scaffold.dart';

/// US-013: slim, regular or relaxed. One choice at a time; skipping saves Regular.
class FitScreen extends StatefulWidget {
  final bool editing;

  const FitScreen({super.key, this.editing = false});

  @override
  State<FitScreen> createState() => _FitScreenState();
}

class _FitScreenState extends State<FitScreen> {
  FitPreference? selected;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await ProfileStore.instance.loadCurrent();
    if (!mounted || p?.fit == null) return;
    setState(() => selected = FitPreferenceCode.fromCode(p!.fit));
  }

  Future<void> _continue() async {
    setState(() => loading = true);
    final fit = selected ?? FitPreference.regular; // AC: nothing chosen means Regular
    await ProfileStore.instance.updateCurrent((p) => p.copyWith(fit: fit.code));
    if (!mounted) return;
    setState(() => loading = false);
    await AppFlow.finishStep(context, editing: widget.editing);
  }

  String _help(FitPreference fit) {
    switch (fit) {
      case FitPreference.slim:
        return AppStrings.fitSlimHelp;
      case FitPreference.regular:
        return AppStrings.fitRegularHelp;
      case FitPreference.relaxed:
        return AppStrings.fitRelaxedHelp;
    }
  }

  /// Width of the drawn shirt, to show the difference at a glance.
  double _shirtWidth(FitPreference fit) => {FitPreference.slim: 26.0, FitPreference.regular: 32.0, FitPreference.relaxed: 40.0}[fit]!;

  @override
  Widget build(BuildContext context) {
    return SetupStepScaffold(
      step: SetupStep.fit,
      editing: widget.editing,
      title: AppStrings.howDoYouLikeFit,
      help: AppStrings.fitHelp,
      loading: loading,
      onContinue: _continue,
      child: ListView.separated(
        itemCount: FitPreference.values.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final fit = FitPreference.values[i];
          final isOn = selected == fit;
          return ChoiceCard(
            selected: isOn,
            title: fit.label,
            subtitle: _help(fit),
            onTap: () => setState(() => selected = fit), // single choice: the others turn off
            leading: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: _shirtWidth(fit),
                  height: 36,
                  decoration: BoxDecoration(
                    color: isOn ? AppColors.blue : AppColors.border,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
