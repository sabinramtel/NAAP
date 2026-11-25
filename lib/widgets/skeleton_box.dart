import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Grey placeholder block shown while data loads (US-017, US-022).
/// It pulses gently, and stays still when the phone asks for less motion.
class SkeletonBox extends StatefulWidget {
  final double? width;
  final double height;
  final double radius;

  const SkeletonBox(
      {super.key, this.width, required this.height, this.radius = 14});

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      controller.stop();
      controller.value = 0.5;
    } else if (!controller.isAnimating) {
      controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(controller),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(widget.radius)),
      ),
    );
  }
}
