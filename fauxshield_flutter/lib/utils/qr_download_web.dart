import 'dart:convert';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Saves [bytes] to the browser's downloads as [filename].
void downloadBytes(
  Uint8List bytes,
  String filename, {
  String mimeType = 'application/octet-stream',
}) {
  _saveDataUrl('data:$mimeType;base64,${base64Encode(bytes)}', filename);
}

/// Saves [text] to the browser's downloads as [filename].
void downloadText(
  String text,
  String filename, {
  String mimeType = 'text/html',
}) {
  _saveDataUrl(
    'data:$mimeType;charset=utf-8,${Uri.encodeComponent(text)}',
    filename,
  );
}

void _saveDataUrl(String href, String filename) {
  final anchor = web.HTMLAnchorElement()
    ..href = href
    ..download = filename;
  web.document.body?.appendChild(anchor);
  anchor.click();
  anchor.remove();
}
