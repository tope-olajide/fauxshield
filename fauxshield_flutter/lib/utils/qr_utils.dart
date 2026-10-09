import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../client.dart' show serverBase;

export 'qr_download.dart' show downloadBytes, downloadText;

/// Maximum identities a synchronous QR export handles, mirroring the
/// reference implementation's `MAX_SYNCHRONOUS_BATCH_QR_EXPORT_CODES`.
/// Larger batches would need an asynchronous export workflow.
const int maxSynchronousQrExport = 500;

/// Builds the public consumer verification URL encoded into a unit's QR code.
///
/// The URL points at the server-rendered `/verify?t=<token>` page:
/// * Served app (any port on the site's origin) uses that origin directly.
/// * Local development serves the public pages on port 8082 while the API
///   lives on 8080, so a local API URL is mapped to the web port — this also
///   covers `flutter run -d chrome`, whose origin is the dev tooling server.
/// * Native targets (no browser origin) fall back to the API host with the
///   same port mapping.
String verificationUrlFor(String token) {
  final api = serverBase;
  final base = Uri.base;
  final browserOrigin =
      (base.scheme == 'http' || base.scheme == 'https') && base.host.isNotEmpty;

  if (browserOrigin && api.hasScheme && base.host == api.host) {
    final isLocalDevApi = api.hasPort && api.port == 8080;
    return Uri(
      scheme: base.scheme,
      host: base.host,
      port: isLocalDevApi ? 8082 : null,
      path: '/verify',
      queryParameters: <String, String>{'t': token},
    ).toString();
  }
  if (browserOrigin) {
    return '${base.origin}/verify?t=$token';
  }
  if (api.hasScheme && api.host.isNotEmpty) {
    return Uri(
      scheme: api.scheme,
      host: api.host,
      port: api.port == 8080 ? 8082 : (api.hasPort ? api.port : null),
      path: '/verify',
      queryParameters: <String, String>{'t': token},
    ).toString();
  }
  return Uri(
    path: '/verify',
    queryParameters: <String, String>{'t': token},
  ).toString();
}

/// Renders [data] as a PNG-encoded QR code of [size] pixels.
///
/// A quiet zone of [quietZone] pixels is painted around the code so the
/// result stays scannable when embedded in a printable sheet, matching the
/// margin the reference implementation's `qrcode` library applies.
Future<Uint8List> qrPng(
  String data, {
  int size = 512,
  int quietZone = 32,
  int errorCorrectionLevel = QrErrorCorrectLevel.M,
}) async {
  final painter = QrPainter(
    data: data,
    version: QrVersions.auto,
    errorCorrectionLevel: errorCorrectionLevel,
    gapless: true,
  );
  final qrPicture = painter.toPicture(size.toDouble());

  final total = size + quietZone * 2;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(
    Rect.fromLTWH(0, 0, total.toDouble(), total.toDouble()),
    Paint()..color = Colors.white,
  );
  canvas.translate(quietZone.toDouble(), quietZone.toDouble());
  canvas.drawPicture(qrPicture);

  final image = await recorder.endRecording().toImage(total, total);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List(
    byteData.offsetInBytes,
    byteData.lengthInBytes,
  );
}
