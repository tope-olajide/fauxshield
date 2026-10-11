import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/device_fingerprint.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';

/// The consumer style verification flow, straight from the command center.
///
/// Mirrors what a shopper sees on the public `/verify` page: resolve a QR
/// token, ask for the packaging PIN, then show the authoritative outcome.
/// Operators use it to sanity check printed codes without leaving the app.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

enum _ScanStage { entry, ready, pin, result }

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _token = TextEditingController();
  final TextEditingController _pin = TextEditingController();

  _ScanStage _stage = _ScanStage.entry;
  VerificationPresentation? _presentation;
  bool _busy = false;
  bool _loadingDemo = false;

  @override
  void dispose() {
    _token.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _run(Future<VerificationPresentation> Function() action) async {
    setState(() => _busy = true);
    try {
      final presentation = await action();
      if (!mounted) return;
      setState(() {
        _presentation = presentation;
        _stage = _stageFor(presentation);
        _busy = false;
        if (_stage != _ScanStage.pin) _pin.clear();
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      showMessage(
        context,
        error is ApiException ? error.message : error.toString(),
        error: true,
      );
      if (_stage == _ScanStage.entry) _token.clear();
    }
  }

  static _ScanStage _stageFor(VerificationPresentation presentation) {
    switch (presentation.state) {
      case VerificationState.tokenResolved:
        return _ScanStage.ready;
      case VerificationState.pinPrompted:
      case VerificationState.pinSubmitted:
        return _ScanStage.pin;
      case VerificationState.resultDetermined:
        return _ScanStage.result;
    }
  }

  Future<void> _start() async {
    final token = _token.text.trim();
    if (token.isEmpty) {
      showMessage(context, 'Enter or scan a QR token first.', error: true);
      return;
    }
    final fingerprint = await DeviceFingerprint.load();
    await _run(() => client.verification.start(token, fingerprint));
  }

  Future<void> _acknowledge() async {
    final presentation = _presentation;
    if (presentation == null) return;
    final fingerprint = await DeviceFingerprint.load();
    await _run(
      () =>
          client.verification.acknowledge(presentation.sessionId, fingerprint),
    );
  }

  Future<void> _submitPin() async {
    final presentation = _presentation;
    if (presentation == null) return;
    final pin = _pin.text.trim();
    if (pin.length != 6) {
      showMessage(context, 'The packaging PIN is 6 digits.', error: true);
      return;
    }
    final fingerprint = await DeviceFingerprint.load();
    await _run(
      () => client.verification.submitPin(
        presentation.sessionId,
        fingerprint,
        pin,
      ),
    );
  }

  Future<void> _loadDemoToken() async {
    setState(() => _loadingDemo = true);
    try {
      final workspaceId = widget.controller.workspaceId;
      final products = await client.product.list(
        workspaceId: workspaceId,
        includeArchived: false,
      );
      if (products.isEmpty) {
        throw ValidationException(message: 'No products to scan yet.');
      }
      for (final product in products) {
        final batches = await client.batch.list(
          workspaceId: workspaceId,
          productId: product.id,
        );
        for (final batch in batches) {
          final identities = await client.identity.list(
            workspaceId: workspaceId,
            batchId: batch.id,
            onlyFlagged: false,
            page: 0,
            pageSize: 1,
          );
          if (identities.isNotEmpty) {
            if (!mounted) return;
            setState(() {
              _token.text = identities.first.qrToken;
              _loadingDemo = false;
              _stage = _ScanStage.entry;
              _presentation = null;
            });
            showMessage(context, 'Loaded a live unit from ${batch.reference}.');
            return;
          }
        }
      }
      throw ValidationException(
        message: 'No serialized units found. Generate some first.',
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingDemo = false);
      showMessage(
        context,
        error is ApiException ? error.message : error.toString(),
        error: true,
      );
    }
  }

  void _reset() {
    setState(() {
      _stage = _ScanStage.entry;
      _presentation = null;
      _token.clear();
      _pin.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify a product'),
        actions: <Widget>[
          if (_stage != _ScanStage.entry)
            TextButton.icon(
              onPressed: _busy ? null : _reset,
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
              label: const Text('New scan'),
            ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: <Widget>[
            _stepIndicator(),
            if (_busy)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              ),
            switch (_stage) {
              _ScanStage.entry => _entry(),
              _ScanStage.ready => _ready(),
              _ScanStage.pin => _pinEntry(),
              _ScanStage.result => _result(),
            },
          ],
        ),
      ),
    );
  }

  Widget _stepIndicator() {
    final labels = <String>['Scan', 'Details', 'PIN', 'Result'];
    final index = _ScanStage.values.indexOf(_stage);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: <Widget>[
          for (var i = 0; i < labels.length; i++) ...<Widget>[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 2,
                  color: i <= index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            CircleAvatar(
              radius: 13,
              backgroundColor: i <= index
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: i <= index
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              child: Text('${i + 1}', style: const TextStyle(fontSize: 11)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _entry() {
    return SectionCard(
      title: 'Enter the code',
      subtitle:
          'Type the token printed on the packaging, or load a live unit from '
          'your catalog.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _token,
            maxLines: 3,
            minLines: 1,
            autofocus: true,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Paste the QR token',
              prefixIcon: Icon(Icons.qr_code_2_rounded),
            ),
            onSubmitted: (_) => _start(),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: _busy ? null : _start,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('Resolve token'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _busy || _loadingDemo ? null : _loadDemoToken,
                icon: _loadingDemo
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.science_rounded),
                label: const Text('Demo unit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ready() {
    final presentation = _presentation!;
    return Column(
      children: <Widget>[
        _productCard(presentation),
        SectionCard(
          title: 'Ready to verify',
          subtitle:
              'Resolved against ${presentation.workspaceName}. Enter the 6 '
              'digit PIN printed under the scratch panel to continue.',
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _acknowledge,
              icon: const Icon(Icons.lock_open_rounded),
              label: const Text('Enter packaging PIN'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pinEntry() {
    final presentation = _presentation!;
    final lastOutcome = presentation.outcome;
    return Column(
      children: <Widget>[
        _productCard(presentation),
        if (lastOutcome == VerificationOutcome.invalidPin)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Card(
              color: Theme.of(context).colorScheme.errorContainer,
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: Icon(
                  Icons.pin_rounded,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                title: Text(
                  'Wrong PIN',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                subtitle: Text(
                  'The code resolved but the PIN did not match. Check the '
                  'packaging and try the verify flow again.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          ),
        SectionCard(
          title: 'Packaging PIN',
          subtitle: 'The server verifies the PIN against the salted hash.',
          child: Column(
            children: <Widget>[
              TextField(
                controller: _pin,
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 26,
                  letterSpacing: 10,
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: '••••••',
                ),
                onSubmitted: (_) => _submitPin(),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _busy ? null : _submitPin,
                  icon: const Icon(Icons.verified_user_rounded),
                  label: const Text('Verify'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _result() {
    final presentation = _presentation!;
    final outcome = presentation.outcome;
    final color = outcomeColor(context, outcome);
    return Column(
      children: <Widget>[
        Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: <Widget>[
                Icon(outcomeIcon(outcome), size: 46, color: color),
                const SizedBox(height: 8),
                Text(
                  outcomeLabel(outcome),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                if (presentation.authenticMessage != null &&
                    outcome == VerificationOutcome.authentic)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      presentation.authenticMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                if (presentation.verifiedByThisDevice != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'You already verified this product on '
                      '${presentation.verifiedByThisDevice!.toIso8601String().split('T').first} '
                      'from this device.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                if (presentation.recallReason != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Recall reason: ${presentation.recallReason}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: color),
                    ),
                  ),
              ],
            ),
          ),
        ),
        _productCard(presentation),
        SectionCard(
          title: 'Verification facts',
          child: Column(
            children: <Widget>[
              InfoRow(label: 'Token', value: presentation.tokenMasked),
              InfoRow(
                label: 'First verified',
                value: presentation.firstVerified ? 'Yes' : 'No',
              ),
              InfoRow(
                label: 'Scan count',
                value: '${presentation.verificationCount}',
              ),
              if (presentation.riskScore != null)
                InfoRow(
                  label: 'Risk score',
                  value: presentation.riskScore!.name,
                ),
              if (presentation.location != null)
                InfoRow(
                  label: 'Location',
                  value:
                      <String?>[
                            presentation.location!.city,
                            presentation.location!.country,
                          ]
                          .whereType<String>()
                          .where((part) => part.isNotEmpty)
                          .join(', '),
                ),
              InfoRow(
                label: 'Batch',
                value: presentation.batchReference,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _reportDialog,
                  icon: const Icon(Icons.report_rounded),
                  label: const Text('Report this product'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: _reset,
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text('Scan another'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _productCard(VerificationPresentation presentation) {
    return SectionCard(
      title: presentation.productName,
      subtitle: <String?>[
        presentation.branding?.displayName ?? presentation.workspaceName,
        if (presentation.sku != null) 'SKU ${presentation.sku}',
      ].whereType<String>().join(' · '),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (presentation.description != null) Text(presentation.description!),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: <Widget>[
              Pill(
                label: presentation.batchReference,
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.inventory_2_rounded,
                dense: true,
              ),
              Pill(
                label: presentation.tokenMasked,
                color: Theme.of(context).colorScheme.outline,
                icon: Icons.qr_code_2_rounded,
                dense: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _reportDialog() async {
    final presentation = _presentation;
    if (presentation == null) return;
    final reason = TextEditingController();
    final comment = TextEditingController();
    final presets = <String>[
      'Looks counterfeit',
      'Packaging is damaged',
      'Wrong PIN did not match',
      'Sold outside my region',
    ];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report this product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: <Widget>[
                  for (final preset in presets)
                    ActionChip(
                      label: Text(preset),
                      onPressed: () => reason.text = preset,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              LabeledField(
                label: 'What looks wrong?',
                controller: reason,
                maxLines: 2,
                hint: 'Describe what you found',
              ),
              LabeledField(
                label: 'Comment (optional)',
                controller: comment,
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send report'),
          ),
        ],
      ),
    );
    if (confirmed == true && reason.text.trim().length >= 3) {
      try {
        final fingerprint = await DeviceFingerprint.load();
        final acknowledgement = await client.verification.reportFake(
          presentation.sessionId,
          fingerprint,
          reason.text.trim(),
          comment: comment.text.trim().isEmpty ? null : comment.text.trim(),
        );
        if (mounted) showMessage(context, acknowledgement.message);
      } catch (error) {
        if (mounted) {
          showMessage(
            context,
            error is ApiException ? error.message : error.toString(),
            error: true,
          );
        }
      }
    }
    reason.dispose();
    comment.dispose();
  }
}
