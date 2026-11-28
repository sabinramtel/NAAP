import 'package:flutter/material.dart';

/// US-024: the main tabs as pages you can swipe between.
///
/// Swiping changes [index] through [onChanged], so the bottom bar highlight
/// follows. Tapping a tab calls [jumpTo] on the state, which slides to that
/// page, or switches without animation when the phone asks for reduced motion.
/// A sideways list inside a page (like Picked for you) wins the drag, so the
/// page only moves when you swipe outside such a list.
/// Each page is kept alive, so its scroll position survives a swipe away.
class SwipeTabs extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<Widget> children;

  const SwipeTabs({super.key, required this.index, required this.onChanged, required this.children});

  @override
  State<SwipeTabs> createState() => SwipeTabsState();
}

class SwipeTabsState extends State<SwipeTabs> {
  late final PageController controller = PageController(initialPage: widget.index);

  /// Moves to [page] after a bottom bar tap.
  void jumpTo(int page) {
    if (!controller.hasClients) return;
    if (MediaQuery.of(context).disableAnimations) {
      controller.jumpToPage(page);
    } else {
      controller.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      onPageChanged: widget.onChanged,
      children: [for (final child in widget.children) _KeepAlive(child: child)],
    );
  }
}

class _KeepAlive extends StatefulWidget {
  final Widget child;

  const _KeepAlive({required this.child});

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
