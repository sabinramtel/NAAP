import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import 'page_dots.dart';
import 'primary_button.dart';

class Slide {
  final IconData icon;
  final String title;
  final String body;

  const Slide({required this.icon, required this.title, required this.body});
}

/// A swipe-through set of slides with Skip, page dots and a Next button that
/// becomes [doneLabel] on the last slide. Used by the welcome screens (US-009)
/// and the first-time Home guide (US-027), so both look and behave the same.
class SlideDeck extends StatefulWidget {
  final List<Slide> slides;
  final String doneLabel;
  final VoidCallback onDone;

  const SlideDeck({super.key, required this.slides, required this.doneLabel, required this.onDone});

  @override
  State<SlideDeck> createState() => _SlideDeckState();
}

class _SlideDeckState extends State<SlideDeck> {
  final PageController controller = PageController();
  int page = 0;

  void _next() {
    if (page == widget.slides.length - 1) {
      widget.onDone();
    } else if (MediaQuery.of(context).disableAnimations) {
      controller.jumpToPage(page + 1);
    } else {
      controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final last = page == widget.slides.length - 1;
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: widget.onDone, child: Text(AppStrings.skip)),
          ),
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: widget.slides.length,
              onPageChanged: (i) => setState(() => page = i),
              itemBuilder: (context, i) {
                final slide = widget.slides[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: const BoxDecoration(color: AppColors.blueSoft, shape: BoxShape.circle),
                          child: Icon(slide.icon, size: 84, color: AppColors.blue),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Text(slide.title,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.navy, height: 1.15)),
                      const SizedBox(height: 12),
                      Text(slide.body,
                          style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5)),
                    ],
                  ),
                );
              },
            ),
          ),
          PageDots(count: widget.slides.length, current: page),
          Padding(
            padding: const EdgeInsets.all(24),
            child: PrimaryButton(label: last ? widget.doneLabel : AppStrings.next, onPressed: _next),
          ),
        ],
      ),
    );
  }
}
