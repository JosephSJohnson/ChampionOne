import 'dart:typed_data';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileStorage {
  FileStorage._();

  static Future<Directory> _getStorageDirectory() async {
    final appDirectory =
        await getApplicationDocumentsDirectory();

    final storageDirectory = Directory(
      path.join(
        appDirectory.path,
        'ChampionOne',
        'staff_files',
      ),
    );

    if (!await storageDirectory.exists()) {
      await storageDirectory.create(
        recursive: true,
      );
    }

    return storageDirectory;
  }

  static Future<String> saveFile(
    Uint8List bytes, {
    required String folder,
    required String fileName,
  }) async {
    final storageDirectory =
        await _getStorageDirectory();

    final folderDirectory = Directory(
      path.join(
        storageDirectory.path,
        folder,
      ),
    );

    if (!await folderDirectory.exists()) {
      await folderDirectory.create(
        recursive: true,
      );
    }

    final savedFileName =
        '${DateTime.now().millisecondsSinceEpoch}_$fileName';

    final destinationPath = path.join(
      folderDirectory.path,
      savedFileName,
    );

    final savedFile = File(destinationPath);

    await savedFile.writeAsBytes(bytes);

    return savedFile.path;
  }

  static Future<String> saveStaffPhoto(
    Uint8List bytes, {
    required String fileName,
  }) async {
    return saveFile(
      bytes,
      folder: 'photos',
      fileName: fileName,
    );
  }

  static Future<String> saveStaffDocument(
    Uint8List bytes, {
    required String fileName,
  }) async {
    return saveFile(
      bytes,
      folder: 'documents',
      fileName: fileName,
    );
  }

    // =========================
  // READ FILE
  // =========================

  static Future<Uint8List?> readFile(
    String filePath,
  ) async {
    if (filePath.isEmpty) {
      return null;
    }

    final file = File(filePath);

    if (!await file.exists()) {
      return null;
    }

    return file.readAsBytes();
  }

    // =========================
  // DELETE FILE
  // =========================

  static Future<bool> deleteFile(
    String filePath,
  ) async {
    if (filePath.isEmpty) {
      return false;
    }

    final file = File(filePath);

    if (!await file.exists()) {
      return false;
    }

    await file.delete();

    return true;
  }
}