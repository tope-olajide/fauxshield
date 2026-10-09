import 'dart:async';

import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../utils/qr_utils.dart';
import 'common.dart';

/// Per-unit QR dialog, mirroring the reference `IdentityQrModal`: the QR
/// image, the raw token, the verification URL with copy-to-clipboard, and a
/// PNG download.
class IdentityQrDialog extends StatefulWidget {
  const IdentityQrDialog({
    super.key,
    required this.identity,
    required this.batchReference,
  });

  final ProductIdentity identity;
  final String batchReference;

  @override
  State<IdentityQrDialog> createState() => _IdentityQrDialogState();
}

class _IdentityQrDialogState extends State<IdentityQrDialog> {
  bool _copied = false;
  bool _preparing = false;

  late final String _url = verificationUrlFor(widget.identity.qrToken);

  Future<void> _copyUrl() async {
    await Clipboard.setData(ClipboardData(text: _url));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  Future<void> _download() async {
    setState(() => _preparing = true);
    try {
      final bytes = await qrPng(_url);
      downloadBytes(
        bytes,
        'qr-${_safeSegment(widget.batchReference)}-'
        '${widget.identity.id!.uuid.substring(0, 8)}.png',
        mimeType: 'image/png',
      );
      if (mounted) showMessage(context, 'QR code downloaded.');
    } catch (error) {
      if (mounted) {
        showMessage(context, 'Could not render the QR code: $error');
      }
    } finally {
      if (mounted) setState(() => _preparing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final identity = widget.identity;

    return AlertDialog(
      title: const Text('Identity QR code'),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'This code opens the consumer verification flow for this '
              'identity.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: QrImageView(
                  data: _url,
                  size: 256,
                  version: QrVersions.auto,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionLabel(text: 'Token'),
            const SizedBox(height: 6),
            _MonoBox(text: identity.qrToken),
            const SizedBox(height: 12),
            _SectionLabel(text: 'Verification URL'),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: _MonoBox(text: _url)),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Copy verification URL',
                  onPressed: _copyUrl,
                  icon: Icon(
                    _copied ? Icons.check_rounded : Icons.content_copy_rounded,
                    size: 18,
                    color: _copied
                        ? const Color(0xFF24A374)
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        FilledButton.icon(
          onPressed: _preparing ? null : _download,
          icon: _preparing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.download_rounded, size: 18),
          label: const Text('Download PNG'),
        ),
      ],
    );
  }
}

/// Uppercase section caption, matching the reference `text-xs font-medium
/// uppercase tracking-wide text-muted-foreground` labels.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Monospace value box on the muted background, matching the reference
/// `break-all rounded-md bg-muted px-3 py-2 font-mono text-xs` styling.
class _MonoBox extends StatelessWidget {
  const _MonoBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: SelectableText(
        text,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }
}

String _safeSegment(String value) {
  final cleaned = value
      .replaceAll(RegExp(r'[^a-zA-Z0-9_-]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return cleaned.isEmpty ? 'batch' : cleaned;
}
