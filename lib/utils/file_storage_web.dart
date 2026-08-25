import 'dart:typed_data';

import 'package:idb_shim/idb_browser.dart';

class FileStorage {
  FileStorage._();

  static const String _databaseName = 'championone_files';
  static const String _storeName = 'staff_files';

  static Future<Database> _getDatabase() async {
    final factory = getIdbFactory();

    if (factory == null) {
      throw UnsupportedError(
        'IndexedDB is not available in this browser.',
      );
    }

    final database = await factory.open(
      _databaseName,
      version: 1,
      onUpgradeNeeded: (VersionChangeEvent event) {
        final db = event.database;

        if (!db.objectStoreNames.contains(_storeName)) {
          db.createObjectStore(_storeName);
        }
      },
    );

    return database;
  }

  // =========================
  // SAVE FILE
  // =========================

  static Future<String> _saveBytes(
    Uint8List bytes, {
    required String folder,
    required String fileName,
  }) async {
    final database = await _getDatabase();

    final key =
        '$folder/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    final transaction = database.transaction(
      _storeName,
      idbModeReadWrite,
    );

    final store = transaction.objectStore(_storeName);

    await store.put(
      bytes,
      key,
    );

    await transaction.completed;

    database.close();

    return key;
  }

  // =========================
  // STAFF PHOTO
  // =========================

  static Future<String> saveStaffPhoto(
    Uint8List bytes, {
    required String fileName,
  }) async {
    return _saveBytes(
      bytes,
      folder: 'photos',
      fileName: fileName,
    );
  }

  // =========================
  // STAFF DOCUMENT
  // =========================

  static Future<String> saveStaffDocument(
    Uint8List bytes, {
    required String fileName,
  }) async {
    return _saveBytes(
      bytes,
      folder: 'documents',
      fileName: fileName,
    );
  }

  // =========================
  // READ FILE
  // =========================

  static Future<Uint8List?> readFile(
    String key,
  ) async {
    if (key.isEmpty) {
      return null;
    }

    final database = await _getDatabase();

    final transaction = database.transaction(
      _storeName,
      idbModeReadOnly,
    );

    final store = transaction.objectStore(
      _storeName,
    );

    final result = await store.getObject(key);

    await transaction.completed;

    database.close();

    if (result == null) {
      return null;
    }

    if (result is Uint8List) {
      return result;
    }

    if (result is List<int>) {
      return Uint8List.fromList(result);
    }

    return null;
  }

  // =========================
  // DELETE FILE
  // =========================

  static Future<bool> deleteFile(
    String key,
  ) async {
    if (key.isEmpty) {
      return false;
    }

    final database = await _getDatabase();

    final transaction = database.transaction(
      _storeName,
      idbModeReadWrite,
    );

    final store = transaction.objectStore(
      _storeName,
    );

    await store.delete(key);

    await transaction.completed;

    database.close();

    return true;
  }
}