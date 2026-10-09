import 'dart:convert';

import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/qr_utils.dart';
import 'common.dart';

/// Batch QR dialog, mirroring the reference `BatchQrDialog`: QR images are
/// generated only on request, the first six preview in a grid, and exports
/// fetch the remaining identities lazily.
class BatchQrDialog extends StatefulWidget {
  const BatchQrDialog({
    super.key,
    required this.controller,
    required this.batch,
    required this.total,
  });

  final AppController controller;
  final Batch batch;

  /// Number of active identities in the batch (from batch stats).
  final int total;

  @override
  State<BatchQrDialog> createState() => _BatchQrDialogState();
}

class _BatchQrDialogState extends State<BatchQrDialog> {
  static const int _pageSize = 50;
  static const int _previewCount = 6;

  bool _requested = false;
  bool _loading = false;
  String? _previewError;
  String? _exportError;
  String? _exporting; // 'html' | 'png'
  List<ProductIdentity> _preview = <ProductIdentity>[];

  bool get _canExportAll =>
      widget.total > 0 && widget.total <= maxSynchronousQrExport;

  Future<void> _loadPreview() {
    setState(() {
      _requested = true;
      _loading = true;
      _previewError = null;
    });
    return _fetch(page: 0, pageSize: _previewCount)
        .then((items) {
          if (!mounted) return;
          setState(() {
            _preview = items;
            _loading = false;
          });
        })
        .catchError((Object error) {
          if (!mounted) return;
          setState(() {
            _previewError = error is ApiException
                ? error.message
                : error.toString();
            _loading = false;
          });
        });
  }

  Future<List<ProductIdentity>> _fetch({
    required int page,
    required int pageSize,
  }) {
    return client.identity.list(
      workspaceId: widget.controller.workspaceId,
      batchId: widget.batch.id,
      onlyFlagged: false,
      page: page,
      pageSize: pageSize,
    );
  }

  /// Loads every exportable identity, in pages, mirroring the reference
  /// implementation's chunked `loadAll`.
  Future<List<ProductIdentity>> _loadAll() async {
    final all = <ProductIdentity>[];
    while (all.length < widget.total && all.length < maxSynchronousQrExport) {
      final items = await _fetch(
        page: all.length ~/ _pageSize,
        pageSize: _pageSize,
      );
      if (items.isEmpty) break;
      all.addAll(items);
      if (items.length < _pageSize) break;
    }
    return all;
  }

  Future<void> _printSheet() async {
    setState(() {
      _exporting = 'html';
      _exportError = null;
    });
    try {
      final items = await _loadAll();
      final cells = StringBuffer();
      for (final identity in items) {
        final png = await qrPng(
          verificationUrlFor(identity.qrToken),
          size: 256,
          quietZone: 16,
        );
        cells.writeln(
          '<figure><img src="data:image/png;base64,${base64Encode(png)}" '
          'alt="QR code" /><figcaption>'
          '${_htmlEscape(identity.qrToken)}</figcaption></figure>',
        );
        // Keep the UI responsive while rendering hundreds of canvases.
        await Future<void>.delayed(Duration.zero);
      }
      downloadText(
        _sheetHtml(
          reference: widget.batch.reference,
          cells: cells.toString(),
        ),
        'qr-${_safeSegment(widget.batch.reference)}-sheet.html',
        mimeType: 'text/html',
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _exportError = error is ApiException
              ? error.message
              : 'Unable to prepare QR sheet';
        });
      }
    } finally {
      if (mounted) setState(() => _exporting = null);
    }
  }

  Future<void> _downloadAllPngs() async {
    setState(() {
      _exporting = 'png';
      _exportError = null;
    });
    try {
      final items = await _loadAll();
      final segment = _safeSegment(widget.batch.reference);
      var sequence = 0;
      for (final identity in items) {
        sequence++;
        final png = await qrPng(verificationUrlFor(identity.qrToken));
        downloadBytes(
          png,
          'qr-$segment-${sequence.toString().padLeft(4, '0')}.png',
          mimeType: 'image/png',
        );
        // Browsers throttle rapid successive downloads; pace them like the
        // reference implementation does.
        await Future<void>.delayed(const Duration(milliseconds: 40));
      }
      if (mounted) {
        showMessage(context, '$sequence QR codes downloaded.');
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _exportError = error is ApiException
              ? error.message
              : 'Unable to download QR codes';
        });
      }
    } finally {
      if (mounted) setState(() => _exporting = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reference = widget.batch.reference;

    return AlertDialog(
      title: Text('QR codes — $reference'),
      content: SizedBox(width: 640, child: _body(theme)),
    );
  }

  Widget _body(ThemeData theme) {
    if (!_requested) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Load the first six QR codes to preview this batch. Printing and '
            'downloads fetch the remaining identities only when you request '
            'them.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _loadPreview,
                child: const Text('Load QR Codes'),
              ),
            ],
          ),
        ],
      );
    }

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 14),
              Text('Generating QR code preview...'),
            ],
          ),
        ),
      );
    }

    if (_previewError != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _NoticeBox(
            message: _previewError!,
            color: theme.colorScheme.error,
            background: theme.colorScheme.errorContainer,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: _loadPreview,
                child: const Text('Retry'),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (_preview.isEmpty)
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'This batch has no active identities to export.',
              style: TextStyle(fontSize: 13),
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              for (final identity in _preview) _QrTile(identity: identity),
            ],
          ),
        if (widget.total > _preview.length) ...<Widget>[
          const SizedBox(height: 10),
          Center(
            child: Text(
              '…and ${widget.total - _preview.length} more QR codes',
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
        if (!_canExportAll) ...<Widget>[
          const SizedBox(height: 12),
          _NoticeBox(
            message:
                'Print and all-PNG downloads are limited to '
                '$maxSynchronousQrExport identities. This batch needs an '
                'asynchronous export workflow.',
            color: const Color(0xFFF59F0A),
            background: theme.colorScheme.surfaceContainer,
          ),
        ],
        if (_exportError != null) ...<Widget>[
          const SizedBox(height: 12),
          _NoticeBox(
            message: _exportError!,
            color: theme.colorScheme.error,
            background: theme.colorScheme.errorContainer,
          ),
        ],
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _exporting != null || !_canExportAll
                  ? null
                  : _printSheet,
              icon: _exporting == 'html'
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.description_outlined, size: 18),
              label: const Text('Print Sheet (HTML)'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _exporting != null || !_canExportAll
                  ? null
                  : _downloadAllPngs,
              icon: _exporting == 'png'
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download_rounded, size: 18),
              label: const Text('Download All PNGs'),
            ),
          ],
        ),
      ],
    );
  }
}

/// One preview tile: white bordered card with the QR image and token,
/// matching the reference grid cells.
class _QrTile extends StatelessWidget {
  const _QrTile({required this.identity});

  final ProductIdentity identity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 180,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          children: <Widget>[
            QrImageView(
              data: verificationUrlFor(identity.qrToken),
              size: 140,
              version: QrVersions.auto,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
              backgroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 6),
            Text(
              identity.qrToken,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bordered notice box, matching the reference warning/error callouts.
class _NoticeBox extends StatelessWidget {
  const _NoticeBox({
    required this.message,
    required this.color,
    required this.background,
  });

  final String message;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 13, color: color),
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

String _htmlEscape(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#039;');
}

/// The printable sheet document, styled like the reference implementation's
/// exported HTML (`@page` margins, three-column grid, 42mm QR cells).
String _sheetHtml({
  required String reference,
  required String cells,
}) {
  final title = _htmlEscape(reference);
  return '''
<!doctype html>
<html><head><meta charset="utf-8"><title>QR sheet $title</title>
<style>
@page { margin: 12mm; }
body { font-family: Arial, sans-serif; color: #111827; }
h1 { font-size: 16pt; margin: 0 0 8mm; }
.grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 7mm; }
figure { margin: 0; break-inside: avoid; border: 1px solid #d1d5db; border-radius: 4px; padding: 4mm; text-align: center; }
img { width: 42mm; height: 42mm; image-rendering: pixelated; }
figcaption { margin-top: 2mm; font-family: ui-monospace, monospace; font-size: 7pt; overflow-wrap: anywhere; }
</style></head><body><h1>QR codes — $title</h1><div class="grid">$cells</div></body></html>''';
}
