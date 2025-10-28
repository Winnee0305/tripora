import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

Future<File> compressUntilUnderLimit(
  File imageFile, {
  int maxSizeMB = 1,
}) async {
  final tempDir = await getTemporaryDirectory();
  final maxBytes = maxSizeMB * 1024 * 1024;
  int quality = 85;

  File compressed = imageFile;

  while (true) {
    final targetPath = path.join(
      tempDir.path,
      "compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
    );

    // ⚡ compressAndGetFile now returns XFile?
    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      compressed.path,
      targetPath,
      quality: quality,
      minWidth: 1080,
      minHeight: 1080,
    );

    if (result == null) break;

    final newFile = File(result.path);
    final fileSize = newFile.lengthSync();

    print(
      "Compressed size at quality $quality: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB",
    );

    if (fileSize <= maxBytes || quality <= 40) {
      return newFile;
    }

    // Reduce quality for next loop
    quality -= 10;
    compressed = newFile;
  }

  return compressed;
}
