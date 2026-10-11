import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import 'api_keys_screen.dart';
import 'audit_screen.dart';
import 'geographic_screen.dart';
import 'notifications_screen.dart';
import 'offline_screen.dart';
import 'recalls_screen.dart';
import 'settings_screen.dart';
import 'simulations_screen.dart';
import 'team_screen.dart';
import 'verifications_screen.dart';
import 'webhooks_screen.dart';

/// The "More" hub: team, integrations, operations, and workspace settings.
class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _signingOut = false;

  Future<void> _signOut() async {
    final confirmed = await confirmAction(
      context,
      title: 'Sign out',
      message: 'You will need to sign in again to reach this workspace.',
      confirmLabel: 'Sign out',
    );
    if (!confirmed) return;
    setState(() => _signingOut = true);
    await client.auth.signOutDevice();
    if (!mounted) return;
    setState(() => _signingOut = false);
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bootstrap = widget.controller.bootstrap;
    final workspace = bootstrap?.workspace;
    final member = bootstrap?.member;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.shield_moon_rounded,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              workspace?.branding?.displayName ??
                                  workspace?.name ??
                                  'FauxShield',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              workspace?.slug ?? '',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (bootstrap?.isDemo ?? false)
                        const Pill(
                          label: 'DEMO',
                          color: Color(0xFF2563EB),
                          dense: true,
                        ),
                    ],
                  ),
                  const Divider(height: 24),
                  InfoRow(
                    label: 'Signed in as',
                    value: member?.displayName ?? member?.email ?? 'Operator',
                  ),
                  InfoRow(
                    label: 'Role',
                    value: bootstrap == null ? '—' : roleLabel(bootstrap.role),
                  ),
                  InfoRow(
                    label: 'Permissions',
                    value: '${bootstrap?.permissions.length ?? 0} granted',
                  ),
                ],
              ),
            ),
          ),
          _section(
            'Team & access',
            <Widget>[
              _tile(
                icon: Icons.groups_rounded,
                title: 'Team & invitations',
                subtitle: 'Members, roles, and invite codes',
                builder: (_) => TeamScreen(controller: widget.controller),
              ),
              _tile(
                icon: Icons.webhook_rounded,
                title: 'Webhooks',
                subtitle: 'Signed deliveries, retries, and secrets',
                builder: (_) => WebhooksScreen(controller: widget.controller),
              ),
              _tile(
                icon: Icons.key_rounded,
                title: 'API keys',
                subtitle: 'Machine credentials with scoped access',
                builder: (_) => ApiKeysScreen(controller: widget.controller),
              ),
              _tile(
                icon: Icons.receipt_long_rounded,
                title: 'Audit log',
                subtitle: 'Every sensitive action, append only',
                builder: (_) => AuditScreen(controller: widget.controller),
              ),
            ],
          ),
          _section(
            'Operations',
            <Widget>[
              _tile(
                icon: Icons.fact_check_rounded,
                title: 'Verifications',
                subtitle: 'Verification activity by risk, outcome, and date',
                builder: (_) =>
                    VerificationsScreen(controller: widget.controller),
              ),
              _tile(
                icon: Icons.campaign_rounded,
                title: 'Recalls',
                subtitle: 'Recall history across batches and units',
                builder: (_) => RecallsScreen(controller: widget.controller),
              ),
              _tile(
                icon: Icons.public_rounded,
                title: 'Geographic',
                subtitle: 'Scan volume and fraud by country',
                builder: (_) => GeographicScreen(controller: widget.controller),
              ),
              _tile(
                icon: Icons.science_rounded,
                title: 'Simulations',
                subtitle: 'Rehearse attacks against the real pipeline',
                builder: (_) =>
                    SimulationsScreen(controller: widget.controller),
              ),
              _tile(
                icon: Icons.cloud_sync_rounded,
                title: 'Offline field scans',
                subtitle: 'Queued inspector scans and verdict backfill',
                builder: (_) => OfflineScreen(controller: widget.controller),
              ),
              _tile(
                icon: Icons.notifications_active_rounded,
                title: 'Notifications',
                subtitle: 'Alerts, digests, and channel preferences',
                builder: (_) =>
                    NotificationsScreen(controller: widget.controller),
              ),
              _tile(
                icon: Icons.tune_rounded,
                title: 'Workspace settings',
                subtitle: 'Branding, restricted countries, fraud policy',
                builder: (_) => SettingsScreen(controller: widget.controller),
              ),
            ],
          ),
          _section(
            'Account',
            <Widget>[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Sign out'),
                subtitle: const Text('End this session on this device'),
                enabled: !_signingOut,
                trailing: _signingOut
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                onTap: _signingOut ? null : _signOut,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'FauxShield · built with Serverpod 4 and Flutter',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return SectionCard(
      title: title,
      child: Column(children: children),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required WidgetBuilder builder,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(builder: builder),
      ),
    );
  }
}
