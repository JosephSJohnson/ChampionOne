import 'dart:typed_data';

class FileStorage {
  FileStorage._();

  static Future<String> saveStaffPhoto(
    Uint8List bytes, {
    required String fileName,
  }) async {
    throw UnsupportedError(
      'Staff photo storage is not supported on this platform.',
    );
  }

  static Future<String> saveStaffDocument(
    Uint8List bytes, {
    required String fileName,
  }) async {
    throw UnsupportedError(
      'Staff document storage is not supported on this platform.',
    );
  }

  static Future<Uint8List?> readFile(
    String filePath,
  ) async {
    throw UnsupportedError(
      'File reading is not supported on this platform.',
    );
  }

  static Future<bool> deleteFile(
    String filePath,
  ) async {
    throw UnsupportedError(
      'File deletion is not supported on this platform.',
    );
  }
}