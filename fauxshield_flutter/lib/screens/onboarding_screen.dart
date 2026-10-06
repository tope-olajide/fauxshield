import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../widgets/common.dart';

/// First run experience: create a workspace, explore the demo, or redeem an
/// invite code.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _inviteCode = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _inviteCode.dispose();
    super.dispose();
  }

  Future<void> _run(Future<bool> Function() action, String success) async {
    setState(() => _busy = true);
    final ok = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      showMessage(context, success);
    } else if (widget.controller.error != null) {
      showMessage(context, widget.controller.error!, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Icon(
                Icons.shield_moon_rounded,
                size: 52,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'FauxShield',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Serialized QR identities, live fraud intelligence, and '
                'offline field inspections for your products.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              SectionCard(
                title: 'Add your brand',
                subtitle: 'Create a workspace you own.',
                child: Column(
                  children: <Widget>[
                    LabeledField(
                      label: 'Workspace name',
                      controller: _name,
                      hint: 'e.g. Aurelia Foods',
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _busy
                            ? null
                            : () => _run(
                                () => widget.controller.createWorkspace(
                                  _name.text.trim(),
                                ),
                                'Workspace created.',
                              ),
                        icon: const Icon(Icons.add_business_rounded),
                        label: const Text('Create workspace'),
                      ),
                    ),
                  ],
                ),
              ),
              SectionCard(
                title: 'Explore the demo',
                subtitle:
                    'Join the public demo workspace: real products, batches, '
                    'verifications, alerts, and simulations.',
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: _busy
                        ? null
                        : () => _run(
                            widget.controller.joinDemo,
                            'Welcome to the demo.',
                          ),
                    icon: const Icon(Icons.travel_explore_rounded),
                    label: const Text('Open demo workspace'),
                  ),
                ),
              ),
              SectionCard(
                title: 'Have an invite?',
                subtitle: 'Redeem the code your teammate shared.',
                child: Column(
                  children: <Widget>[
                    LabeledField(
                      label: 'Invite code',
                      controller: _inviteCode,
                      hint: 'Paste the code',
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _busy
                            ? null
                            : () => _run(
                                () => widget.controller.acceptInvitation(
                                  _inviteCode.text.trim(),
                                ),
                                'Invitation accepted.',
                              ),
                        icon: const Icon(Icons.group_add_rounded),
                        label: const Text('Join workspace'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
