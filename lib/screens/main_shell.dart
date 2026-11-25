import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import 'home_screen.dart';
import 'tabs/coming_soon_tab.dart';
import 'tabs/profile_tab.dart';

/// US-018: the five main tabs with a labelled bottom bar.
///
/// IndexedStack keeps every tab alive, so switching back keeps its scroll
/// position. Each tab has its own ScrollController; tapping the tab you are
/// already on scrolls it back to the top.
/// NavigationBar gives each destination its label and "selected" state to
/// screen readers (TalkBack reads e.g. "Home, tab 1 of 5, selected").
class MainShell extends StatefulWidget {
  final int initialTab;

  const MainShell({super.key, this.initialTab = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const int tabCount = 5;
  static const int tryOnTab = 2;

  late int index = widget.initialTab;
  final List<ScrollController> controllers =
      List.generate(tabCount, (_) => ScrollController());

  void _select(int i) {
    if (i == index) {
      final c = controllers[i];
      if (c.hasClients) {
        final reduceMotion = MediaQuery.of(context).disableAnimations;
        reduceMotion
            ? c.jumpTo(0)
            : c.animateTo(0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut);
      }
      return;
    }
    setState(() => index = i);
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          HomeScreen(
              scrollController: controllers[0],
              onOpenTryOn: () => _select(tryOnTab)),
          ComingSoonTab(
              title: AppStrings.tabExplore,
              icon: Icons.search,
              scrollController: controllers[1]),
          ComingSoonTab(
              title: AppStrings.tabTryOn,
              icon: Icons.checkroom,
              scrollController: controllers[2]),
          ComingSoonTab(
              title: AppStrings.tabSaved,
              icon: Icons.favorite_border,
              scrollController: controllers[3]),
          ProfileTab(scrollController: controllers[4]),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: _select,
        labelBehavior: NavigationDestinationLabelBehavior
            .alwaysShow, // AC: every tab has a text label
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: AppStrings.tabHome),
          NavigationDestination(
              icon: const Icon(Icons.search),
              selectedIcon: const Icon(Icons.saved_search),
              label: AppStrings.tabExplore),
          NavigationDestination(
              icon: const Icon(Icons.checkroom_outlined),
              selectedIcon: const Icon(Icons.checkroom),
              label: AppStrings.tabTryOn),
          NavigationDestination(
              icon: const Icon(Icons.favorite_border),
              selectedIcon: const Icon(Icons.favorite),
              label: AppStrings.tabSaved),
          NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: AppStrings.tabProfile),
        ],
      ),
    );
  }
}
