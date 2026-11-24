import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_flow.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/profile_store.dart';
import '../utils/unit_converter.dart';
import '../widgets/height_ruler.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

/// US-012: pick height on a ruler or type it, in cm or ft/in. Height is always
/// stored in whole centimetres; feet and inches are only for display.
class HeightScreen extends StatefulWidget {
  final bool editing;

  const HeightScreen({super.key, this.editing = false});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  static const int defaultCm = 165;

  UserProfile? profile;
  int heightCm = defaultCm;
  bool imperial = false;
  bool loading = false;
  bool ready = false;

  // Changing this key rebuilds the ruler at a new position after typed input.
  int rulerVersion = 0;

  String get email => AuthService.instance.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await ProfileStore.instance.load(email);
    if (!mounted) return;
    setState(() {
      profile = p;
      heightCm = p?.heightCm ?? defaultCm;
      imperial = p?.prefersImperial ?? false;
      ready = true;
    });
  }

  Future<void> _typeHeight() async {
    final typed = await showDialog<int>(
      context: context,
      builder: (_) => _TypeHeightDialog(startCm: heightCm, imperial: imperial),
    );
    if (typed == null) return;
    setState(() {
      heightCm = typed;
      rulerVersion++;
    });
  }

  Future<void> _save() async {
    if (!UnitConverter.isHeightValid(heightCm)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.heightOutOfRange)));
      return;
    }
    setState(() => loading = true);
    final base = profile ?? UserProfile(name: AuthService.instance.currentUser?.name ?? '');
    await ProfileStore.instance.save(email, base.copyWith(heightCm: heightCm, prefersImperial: imperial));
    if (!mounted) return;
    if (widget.editing) {
      Navigator.of(context).pop(true);
    } else {
      AppFlow.goAndClear(context, const HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final shown = imperial ? UnitConverter.formatFeetInches(heightCm) : UnitConverter.formatCm(heightCm);
    final other = imperial ? UnitConverter.formatCm(heightCm) : UnitConverter.formatFeetInches(heightCm);
    return Scaffold(
      appBar: AppBar(title: Text(widget.editing ? 'Edit height' : 'Step 2 of 2')),
      body: SafeArea(
        child: !ready
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(AppStrings.howTall,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    const SizedBox(height: 6),
                    const Text(AppStrings.heightHelp, style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 20),
                    Center(
                      child: SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: false, label: Text(AppStrings.centimetres)),
                          ButtonSegment(value: true, label: Text(AppStrings.feetInches)),
                        ],
                        selected: {imperial},
                        onSelectionChanged: (s) => setState(() => imperial = s.first),
                      ),
                    ),
                    const Spacer(),
                    // Tap the number to type it instead of dragging.
                    Semantics(
                      button: true,
                      label: 'Type your height',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _typeHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              Text(shown,
                                  style: const TextStyle(
                                      fontSize: 44, fontWeight: FontWeight.w800, color: AppColors.navy)),
                              Text('$other  ·  tap to type',
                                  style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    HeightRuler(
                      key: ValueKey(rulerVersion),
                      min: UnitConverter.minHeightCm,
                      max: UnitConverter.maxHeightCm,
                      value: heightCm,
                      onChanged: (v) => setState(() => heightCm = v),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: widget.editing ? AppStrings.save : AppStrings.continueText,
                      loading: loading,
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Small dialog for typing height. Returns whole centimetres, or null on cancel.
class _TypeHeightDialog extends StatefulWidget {
  final int startCm;
  final bool imperial;

  const _TypeHeightDialog({required this.startCm, required this.imperial});

  @override
  State<_TypeHeightDialog> createState() => _TypeHeightDialogState();
}

class _TypeHeightDialogState extends State<_TypeHeightDialog> {
  late final TextEditingController first;
  late final TextEditingController second;
  String? error;

  @override
  void initState() {
    super.initState();
    if (widget.imperial) {
      final v = UnitConverter.cmToFeetInches(widget.startCm);
      first = TextEditingController(text: '${v.feet}');
      second = TextEditingController(text: '${v.inches}');
    } else {
      first = TextEditingController(text: '${widget.startCm}');
      second = TextEditingController();
    }
  }

  void _done() {
    final a = int.tryParse(first.text.trim());
    final b = int.tryParse(second.text.trim()) ?? 0;
    int? cm;
    if (a != null) {
      if (widget.imperial) {
        cm = b >= 0 && b < 12 ? UnitConverter.feetInchesToCm(a, b) : null;
      } else {
        cm = a;
      }
    }
    if (cm == null || !UnitConverter.isHeightValid(cm)) {
      setState(() => error = AppStrings.heightOutOfRange);
      return;
    }
    Navigator.of(context).pop(cm);
  }

  @override
  void dispose() {
    first.dispose();
    second.dispose();
    super.dispose();
  }

  Widget _box(TextEditingController c, String suffix) => Expanded(
        child: TextField(
          controller: c,
          autofocus: identical(c, first),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
          decoration: InputDecoration(suffixText: suffix, border: const OutlineInputBorder()),
          onSubmitted: (_) => _done(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Type your height'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: widget.imperial
                ? [_box(first, 'ft'), const SizedBox(width: 12), _box(second, 'in')]
                : [_box(first, 'cm')],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(error!, style: const TextStyle(color: AppColors.error)),
            ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text(AppStrings.cancel)),
        FilledButton(onPressed: _done, child: const Text(AppStrings.save)),
      ],
    );
  }
}
