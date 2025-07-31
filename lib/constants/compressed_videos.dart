import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:video_compress/video_compress.dart';

class MediaCompressionHelper {
  /// Compress a video file using video_compress plugin
  static Future<File?> compressVideo(File videoFile) async {
    try {
      final originalSizeInMB = await _getSizeInMB(videoFile);
      print(
          "🟢 Original video size: ${originalSizeInMB.toStringAsFixed(2)} MB");

      final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false,
        frameRate: 10,
        includeAudio: true,
      );

      if (compressedVideo?.file != null) {
        final compressedSizeInMB = await _getSizeInMB(compressedVideo!.file!);
        print(
            "🔻 Compressed video size: ${compressedSizeInMB.toStringAsFixed(2)} MB");
        return compressedVideo.file;
      }

      return null;
    } catch (e) {
      print('❌ Video compression failed: $e');
      return null;
    }
  }

  /// Compress an image file using image package
  static Future<File?> compressImage(File file, {int quality = 50}) async {
    try {
      final image = img.decodeImage(await file.readAsBytes());
      if (image == null) return null;

      final compressed = img.encodeJpg(image, quality: quality);
      final newPath =
          '${file.parent.path}/compressed_${file.uri.pathSegments.last}';

      final compressedFile = File(newPath)..writeAsBytesSync(compressed);
      print("🖼️ Image compressed: ${compressedFile.path}");

      return compressedFile;
    } catch (e) {
      print('❌ Image compression failed: $e');
      return null;
    }
  }

  /// Utility: Get file size in MB
  static Future<double> _getSizeInMB(File file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }
}
