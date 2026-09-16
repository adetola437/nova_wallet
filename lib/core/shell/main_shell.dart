import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../widgets/nova_bottom_nav.dart';

/// Hosts the three tabs (Home · NovaSave · Profile) in an indexed stack, so
/// each tab keeps its scroll position and nested navigation.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NovaBottomNav(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        ),
      ),
    );
  }
}
