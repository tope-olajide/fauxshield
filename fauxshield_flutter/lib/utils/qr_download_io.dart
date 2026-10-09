import 'dart:io';
import 'dart:typed_data';

/// Saves [bytes] to a file in the current working directory.
void downloadBytes(
  Uint8List bytes,
  String filename, {
  String mimeType = 'application/octet-stream',
}) {
  File(filename).writeAsBytesSync(bytes, flush: true);
}

/// Saves [text] to a file in the current working directory.
void downloadText(
  String text,
  String filename, {
  String mimeType = 'text/html',
}) {
  File(filename).writeAsStringSync(text, flush: true);
}
