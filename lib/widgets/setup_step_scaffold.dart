import 'package:flutter/material.dart';

import '../app_flow.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import 'primary_button.dart';

/// Shared layout for the Sprint 2 setup steps (language, fit, styles, brands):
/// step label, title, help text, content, and a button pinned to the bottom.
/// In [editing] mode (opened from Profile) the step label becomes a back arrow
/// and the button says Save.
class SetupStepScaffold extends StatelessWidget {
  final SetupStep step;
  final bool editing;
  final String title;
  final String help;
  final Widget child;
  final VoidCallback? onContinue;
  final String? buttonLabel;
  final bool loading;
  final Widget? footer;

  const SetupStepScaffold({
    super.key,
    required this.step,
    required this.editing,
    required this.title,
    required this.help,
    required this.child,
    required this.onContinue,
    this.buttonLabel,
    this.loading = false,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(editing ? title : AppFlow.stepLabel(step))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!editing) ...[
                Text(title,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy)),
                const SizedBox(height: 6),
              ],
              Text(help,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              Expanded(child: child),
              if (footer != null) footer!,
              const SizedBox(height: 12),
              PrimaryButton(
                label: buttonLabel ??
                    (editing ? AppStrings.save : AppStrings.continueText),
                loading: loading,
                onPressed: onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
