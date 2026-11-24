import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Drag-to-pick height ruler for US-012. One tick = 1 cm.
///
/// Every tick has the same width ([tickWidth]), so the picked value is just
/// scroll offset / tick width, rounded: O(1) per scroll event. ListView.builder
/// with a fixed itemExtent only builds the ticks on screen, so the ruler stays
/// light even with 130+ ticks.
class HeightRuler extends StatefulWidget {
  final int min;
  final int max;
  final int value;
  final ValueChanged<int> onChanged;

  const HeightRuler({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  @override
  State<HeightRuler> createState() => _HeightRulerState();
}

class _HeightRulerState extends State<HeightRuler> {
  static const double tickWidth = 12;
  late final ScrollController controller;
  late int current;

  @override
  void initState() {
    super.initState();
    current = widget.value.clamp(widget.min, widget.max);
    controller = ScrollController(initialScrollOffset: (current - widget.min) * tickWidth);
    controller.addListener(_onScroll);
  }

  void _onScroll() {
    final v = (widget.min + (controller.offset / tickWidth).round()).clamp(widget.min, widget.max);
    if (v != current) {
      setState(() => current = v);
      widget.onChanged(v);
    }
  }

  /// When the finger lifts, settle exactly on the nearest centimetre.
  bool _snap(ScrollEndNotification n) {
    final target = (current - widget.min) * tickWidth;
    if ((controller.offset - target).abs() > 0.5) {
      Future.microtask(() => controller.animateTo(target,
          duration: const Duration(milliseconds: 180), curve: Curves.easeOut));
    }
    return false;
  }

  @override
  void dispose() {
    controller.removeListener(_onScroll);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Height ruler',
      value: '$current centimetres',
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: LayoutBuilder(builder: (context, box) {
          final side = box.maxWidth / 2 - tickWidth / 2;
          return Stack(
            alignment: Alignment.center,
            children: [
              NotificationListener<ScrollEndNotification>(
                onNotification: _snap,
                child: ListView.builder(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: side),
                  itemExtent: tickWidth,
                  itemCount: widget.max - widget.min + 1,
                  itemBuilder: (context, i) {
                    final cm = widget.min + i;
                    final major = cm % 5 == 0;
                    return Column(
                      children: [
                        const SizedBox(height: 14),
                        Container(
                          width: 2,
                          height: major ? 34 : 18,
                          color: major ? AppColors.textSecondary : AppColors.border,
                        ),
                        const SizedBox(height: 6),
                        if (cm % 10 == 0)
                          OverflowBox(
                            maxWidth: 40,
                            child: Text('$cm',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ),
                      ],
                    );
                  },
                ),
              ),
              // Fixed blue needle in the middle
              IgnorePointer(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 4,
                    height: 52,
                    decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
