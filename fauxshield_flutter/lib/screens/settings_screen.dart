import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../widgets/common.dart';

/// Workspace settings: branding, restricted countries, and fraud policy.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _tagline = TextEditingController();
  final TextEditingController _themeColor = TextEditingController();
  final TextEditingController _authenticMessage = TextEditingController();
  final TextEditingController _countries = TextEditingController();
  final TextEditingController _velocityWindow = TextEditingController();
  final TextEditingController _velocityThreshold = TextEditingController();
  final TextEditingController _pinAttackThreshold = TextEditingController();
  final TextEditingController _cloneWindow = TextEditingController();
  final TextEditingController _cloneDistance = TextEditingController();
  late bool _autoLock;
  late bool _alertOnHigh;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final workspace = widget.controller.bootstrap?.workspace;
    _name.text = workspace?.name ?? '';
    _displayName.text = workspace?.branding?.displayName ?? '';
    _tagline.text = workspace?.branding?.tagline ?? '';
    _themeColor.text = workspace?.branding?.themeColor ?? '';
    _authenticMessage.text = workspace?.authenticMessage ?? '';
    _countries.text = (workspace?.restrictedCountries ?? <String>[]).join(', ');
    final policy = workspace?.fraudPolicy;
    _velocityWindow.text = '${policy?.velocityWindowMinutes ?? 30}';
    _velocityThreshold.text = '${policy?.velocityThreshold ?? 8}';
    _pinAttackThreshold.text = '${policy?.pinAttackThreshold ?? 5}';
    _cloneWindow.text = '${policy?.cloneWindowMinutes ?? 120}';
    _cloneDistance.text = '${policy?.cloneDistanceThresholdKm ?? 500}';
    _autoLock = policy?.autoLockOnFraud ?? true;
    _alertOnHigh = policy?.alertOnHigh ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _displayName.dispose();
    _tagline.dispose();
    _themeColor.dispose();
    _authenticMessage.dispose();
    _countries.dispose();
    _velocityWindow.dispose();
    _velocityThreshold.dispose();
    _pinAttackThreshold.dispose();
    _cloneWindow.dispose();
    _cloneDistance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = widget.controller.can('workspaceWrite');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace settings'),
        actions: <Widget>[
          if (canWrite)
            TextButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_rounded, size: 18),
              label: const Text('Save'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          if (!canWrite)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline_rounded),
                  title: Text('Read-only'),
                  subtitle: Text(
                    'Your role can view settings but not change them.',
                  ),
                ),
              ),
            ),
          SectionCard(
            title: 'Brand',
            subtitle: 'Shown to consumers on the verification page.',
            child: Column(
              children: <Widget>[
                LabeledField(label: 'Workspace name', controller: _name),
                LabeledField(
                  label: 'Consumer display name',
                  controller: _displayName,
                  hint: 'Falls back to the workspace name',
                ),
                LabeledField(label: 'Tagline', controller: _tagline),
                LabeledField(
                  label: 'Theme color (hex)',
                  controller: _themeColor,
                  hint: '#0f766e',
                ),
                LabeledField(
                  label: 'Authentic message',
                  controller: _authenticMessage,
                  maxLines: 2,
                  hint: 'Shown when a product verifies as authentic',
                ),
              ],
            ),
          ),
          SectionCard(
            title: 'Restricted countries',
            subtitle:
                'Scans from these countries raise a grey market signal. '
                'Comma separated names or ISO codes.',
            child: LabeledField(
              label: 'Countries',
              controller: _countries,
              maxLines: 2,
              hint: 'CN, RU, TR',
            ),
          ),
          SectionCard(
            title: 'Fraud policy',
            subtitle: 'Thresholds the fraud engine evaluates on every scan.',
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: LabeledField(
                        label: 'Velocity window (min)',
                        controller: _velocityWindow,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LabeledField(
                        label: 'Velocity threshold',
                        controller: _velocityThreshold,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: LabeledField(
                        label: 'PIN attack threshold',
                        controller: _pinAttackThreshold,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LabeledField(
                        label: 'Clone window (min)',
                        controller: _cloneWindow,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                LabeledField(
                  label: 'Clone distance threshold (km)',
                  controller: _cloneDistance,
                  keyboardType: TextInputType.number,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Auto-lock on fraud'),
                  subtitle: const Text('Lock the unit when fraud is suspected'),
                  value: _autoLock,
                  onChanged: canWrite
                      ? (value) => setState(() => _autoLock = value)
                      : null,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Alert on high risk'),
                  subtitle: const Text('Raise alerts for high risk scans'),
                  value: _alertOnHigh,
                  onChanged: canWrite
                      ? (value) => setState(() => _alertOnHigh = value)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final workspace = widget.controller.bootstrap?.workspace;
    if (workspace == null) return;
    setState(() => _saving = true);
    try {
      final countries = _countries.text
          .split(',')
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty)
          .toList();
      await client.workspace.update(
        workspaceId: widget.controller.workspaceId,
        name: _name.text.trim().isEmpty ? null : _name.text.trim(),
        branding: Branding(
          displayName: _displayName.text.trim().isEmpty
              ? null
              : _displayName.text.trim(),
          tagline: _tagline.text.trim().isEmpty ? null : _tagline.text.trim(),
          themeColor: _themeColor.text.trim().isEmpty
              ? null
              : _themeColor.text.trim(),
          logoUrl: workspace.branding?.logoUrl,
        ),
        authenticMessage: _authenticMessage.text.trim(),
        restrictedCountries: countries,
        fraudPolicy: FraudPolicy(
          velocityWindowMinutes: int.tryParse(_velocityWindow.text),
          velocityThreshold: int.tryParse(_velocityThreshold.text),
          pinAttackThreshold: int.tryParse(_pinAttackThreshold.text),
          cloneWindowMinutes: int.tryParse(_cloneWindow.text),
          cloneDistanceThresholdKm: int.tryParse(_cloneDistance.text),
          autoLockOnFraud: _autoLock,
          alertOnHigh: _alertOnHigh,
        ),
      );
      await widget.controller.refresh();
      if (mounted) showMessage(context, 'Settings saved.');
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          error is ApiException ? error.message : error.toString(),
          error: true,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
