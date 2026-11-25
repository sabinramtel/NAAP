import 'package:flutter/material.dart';

import '../../app_flow.dart';
import '../../constants/app_strings.dart';
import '../../services/language_controller.dart';
import '../../services/profile_store.dart';
import '../../widgets/choice_card.dart';
import '../../widgets/setup_step_scaffold.dart';

/// US-016: English or Nepali. Tapping an option switches the whole app
/// straight away, so the user sees the result before pressing Continue.
class LanguageScreen extends StatefulWidget {
  final bool editing;

  const LanguageScreen({super.key, this.editing = false});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool loading = false;

  Future<void> _pick(AppLanguage language) async {
    await LanguageController.instance.change(language);
    if (mounted) setState(() {});
  }

  Future<void> _continue() async {
    setState(() => loading = true);
    await ProfileStore.instance.updateCurrent(
        (p) => p.copyWith(language: LanguageController.instance.code));
    if (!mounted) return;
    setState(() => loading = false);
    await AppFlow.finishStep(context, editing: widget.editing);
  }

  Widget _option(AppLanguage language, String label, String sample) =>
      ChoiceCard(
        selected: LanguageController.instance.value == language,
        title: label,
        subtitle: sample,
        onTap: () => _pick(language),
      );

  @override
  Widget build(BuildContext context) {
    return SetupStepScaffold(
      step: SetupStep.language,
      editing: widget.editing,
      title: AppStrings.chooseLanguage,
      help: AppStrings.languageHelp,
      loading: loading,
      onContinue: _continue,
      child: ListView(
        children: [
          _option(AppLanguage.english, AppStrings.english, 'Welcome to NAAP'),
          const SizedBox(height: 12),
          _option(AppLanguage.nepali, AppStrings.nepali, 'नापमा स्वागत छ'),
        ],
      ),
    );
  }
}
