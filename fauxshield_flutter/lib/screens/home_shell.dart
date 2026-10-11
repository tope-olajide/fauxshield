import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import 'alerts_screen.dart';
import 'catalog_screen.dart';
import 'dashboard_screen.dart';
import 'live_feed_screen.dart';
import 'more_screen.dart';

/// The command center shell.
///
/// Wide layouts (desktop browsers, large tablets) get an inspiration-style
/// left sidebar: brand header, workspace card, icon navigation with an
/// active highlight, and a user footer with sign out. Narrow layouts keep
/// the bottom navigation bar for one-handed use.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.controller});

  final AppController controller;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

/// One entry of the sidebar / bottom navigation.
class _Destination {
  const _Destination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const List<_Destination> _destinations = <_Destination>[
  _Destination(
    label: 'Overview',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard_rounded,
  ),
  _Destination(
    label: 'Live feed',
    icon: Icons.sensors_outlined,
    selectedIcon: Icons.sensors_rounded,
  ),
  _Destination(
    label: 'Alert center',
    icon: Icons.gpp_maybe_outlined,
    selectedIcon: Icons.gpp_maybe_rounded,
  ),
  _Destination(
    label: 'Products',
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2_rounded,
  ),
  _Destination(
    label: 'More',
    icon: Icons.more_horiz_outlined,
    selectedIcon: Icons.more_horiz_rounded,
  ),
];

/// Width below which the shell falls back to the bottom navigation bar.
const double _sidebarBreakpoint = 900;

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  bool _signingOut = false;

  List<Widget> get _pages => <Widget>[
    DashboardScreen(controller: widget.controller),
    LiveFeedScreen(controller: widget.controller),
    AlertsScreen(controller: widget.controller),
    CatalogScreen(controller: widget.controller),
    MoreScreen(controller: widget.controller),
  ];

  void _select(int index) => setState(() => _index = index);

  Future<void> _signOut() async {
    final confirmed = await confirmAction(
      context,
      title: 'Sign out',
      message: 'You will need to sign in again to reach this workspace.',
      confirmLabel: 'Sign out',
    );
    if (!confirmed || !mounted) return;
    setState(() => _signingOut = true);
    await client.auth.signOutDevice();
    if (!mounted) return;
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _sidebarBreakpoint) {
          // Narrow / mobile: keep the bottom navigation bar.
          return Scaffold(
            body: IndexedStack(index: _index, children: pages),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: _select,
              destinations: const <NavigationDestination>[
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded),
                  label: 'Overview',
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
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2_rounded),
                  label: 'Products',
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

        // Wide: inspiration-style left sidebar.
        return Scaffold(
          body: Row(
            children: <Widget>[
              _Sidebar(
                controller: widget.controller,
                index: _index,
                onSelect: _select,
                signingOut: _signingOut,
                onSignOut: _signOut,
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                child: IndexedStack(index: _index, children: pages),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The left sidebar: brand header, workspace card, navigation, user footer.
class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.controller,
    required this.index,
    required this.onSelect,
    required this.signingOut,
    required this.onSignOut,
  });

  final AppController controller;
  final int index;
  final ValueChanged<int> onSelect;
  final bool signingOut;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bootstrap = controller.bootstrap;
    final workspace = bootstrap?.workspace;
    final member = bootstrap?.member;
    final workspaceName =
        workspace?.branding?.displayName ?? workspace?.name ?? 'FauxShield';
    final roleText = bootstrap == null ? 'Operator' : roleLabel(bootstrap.role);

    return Container(
      width: 256,
      color: scheme.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Brand header.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: <Widget>[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.shield_rounded,
                    size: 16,
                    color: scheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'FauxShield',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Workspace card (opens the More hub, like the workspace switcher).
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () => onSelect(4),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: scheme.primary.withValues(alpha: 0.15),
                      child: Text(
                        workspaceName.isNotEmpty
                            ? workspaceName[0].toUpperCase()
                            : 'F',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            workspaceName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            roleText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.unfold_more_rounded,
                      size: 16,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Navigation.
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: _destinations.length,
              separatorBuilder: (_, _) => const SizedBox(height: 2),
              itemBuilder: (context, i) {
                final destination = _destinations[i];
                return _NavItem(
                  icon: i == index
                      ? destination.selectedIcon
                      : destination.icon,
                  label: destination.label,
                  selected: i == index,
                  onTap: () => onSelect(i),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // User footer + sign out.
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: scheme.primary.withValues(alpha: 0.15),
                      child: Text(
                        (member?.displayName ?? member?.email ?? workspaceName)
                                .isNotEmpty
                            ? (member?.displayName ?? member?.email ?? 'O')[0]
                                  .toUpperCase()
                            : 'O',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            member?.displayName ?? member?.email ?? 'Operator',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            roleText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _SignOutTile(
                  enabled: !signingOut,
                  onTap: onSignOut,
                  busy: signingOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single navigation row with hover + active states, mirroring the
/// reference sidebar link styles:
/// active = `bg-primary/12 text-primary font-medium` + trailing chevron,
/// hover = `bg-accent text-foreground`.
class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selected = widget.selected;

    final Color background;
    if (selected) {
      background = scheme.primary.withValues(alpha: 0.12);
    } else if (_hovered) {
      background = scheme.surfaceContainerHigh;
    } else {
      background = Colors.transparent;
    }

    final Color foreground;
    if (selected) {
      foreground = scheme.primary;
    } else if (_hovered) {
      foreground = scheme.onSurface;
    } else {
      foreground = scheme.onSurfaceVariant;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: <Widget>[
              Icon(widget.icon, size: 18, color: foreground),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: foreground,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: scheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sign-out row in the sidebar footer; turns red on hover like the
/// reference `hover:bg-destructive/10 hover:text-destructive` button.
class _SignOutTile extends StatefulWidget {
  const _SignOutTile({
    required this.enabled,
    required this.busy,
    required this.onTap,
  });

  final bool enabled;
  final bool busy;
  final VoidCallback onTap;

  @override
  State<_SignOutTile> createState() => _SignOutTileState();
}

class _SignOutTileState extends State<_SignOutTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final destructiveHover = _hovered && widget.enabled;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.enabled ? widget.onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: destructiveHover
                ? scheme.error.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: <Widget>[
              if (widget.busy)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: scheme.onSurfaceVariant,
                  ),
                )
              else
                Icon(
                  Icons.logout_rounded,
                  size: 16,
                  color: destructiveHover
                      ? scheme.error
                      : scheme.onSurfaceVariant,
                ),
              const SizedBox(width: 10),
              Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: destructiveHover
                      ? scheme.error
                      : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
