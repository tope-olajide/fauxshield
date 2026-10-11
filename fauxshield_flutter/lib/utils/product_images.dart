import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import '../client.dart';

/// A validated image picked by the user, awaiting upload.
class PickedImage {
  const PickedImage({required this.fileName, required this.bytes});

  final String fileName;
  final Uint8List bytes;
}

/// Mirrors the server limits: PNG/JPEG/WebP/SVG, 2 MB each, five per product.
const int maxProductImages = 5;
const int maxProductImageBytes = 2 * 1024 * 1024;
const List<String> productImageExtensions = <String>[
  'png',
  'jpg',
  'jpeg',
  'webp',
  'svg',
];

/// Opens the platform file picker and returns the validated images.
///
/// Throws with a human readable message when a file is unreadable, larger
/// than 2 MB, or when the selection would exceed [maxProductImages] once
/// combined with [existingCount].
Future<List<PickedImage>> pickProductImages({int existingCount = 0}) async {
  final files = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: productImageExtensions,
  );
  if (files.isEmpty) return const <PickedImage>[];
  if (existingCount + files.length > maxProductImages) {
    throw Exception(
      'A product can have at most $maxProductImages images. '
      'Remove some before adding more.',
    );
  }
  final picked = <PickedImage>[];
  for (final file in files) {
    final knownSize = file.lengthSync();
    if (knownSize != null && knownSize > maxProductImageBytes) {
      throw Exception('${file.name} is larger than 2 MB.');
    }
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      throw Exception('${file.name} could not be read. Try another file.');
    }
    if (bytes.length > maxProductImageBytes) {
      throw Exception('${file.name} is larger than 2 MB.');
    }
    picked.add(PickedImage(fileName: file.name, bytes: bytes));
  }
  return picked;
}

/// Uploads each image and returns the public URLs to store on the product.
Future<List<String>> uploadProductImages(List<PickedImage> images) async {
  final urls = <String>[];
  for (final image in images) {
    final url = await client.product.uploadImage(
      fileName: image.fileName,
      data: base64Encode(image.bytes),
    );
    urls.add(url);
  }
  return urls;
}
