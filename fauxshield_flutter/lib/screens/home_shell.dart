import 'package:flutter/material.dart';

import '../app/app_state.dart';
import 'alerts_screen.dart';
import 'catalog_screen.dart';
import 'dashboard_screen.dart';
import 'live_feed_screen.dart';
import 'more_screen.dart';

/// The command center shell.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.controller});

  final AppController controller;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardScreen(controller: widget.controller),
      LiveFeedScreen(controller: widget.controller),
      AlertsScreen(controller: widget.controller),
      CatalogScreen(controller: widget.controller),
      MoreScreen(controller: widget.controller),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.sensors_outlined),
            selectedIcon: Icon(Icons.sensors_rounded),
            label: 'Live',
          ),
          NavigationDestination(
            icon: Icon(Icons.gpp_maybe_outlined),
            selectedIcon: Icon(Icons.gpp_maybe_rounded),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_2_outlined),
            selectedIcon: Icon(Icons.qr_code_2_rounded),
            label: 'Catalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz_outlined),
            selectedIcon: Icon(Icons.more_horiz_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
