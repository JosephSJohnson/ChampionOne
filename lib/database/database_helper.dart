import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;


  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }



  Future<Database> _initDatabase() async {

    final databasePath =
        await getDatabasesPath();

    final path = join(
      databasePath,
      "championone.db",
    );


    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

  }



  Future<void> _onCreate(
    Database db,
    int version,
  ) async {

    await db.execute('''
      CREATE TABLE staff(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        staffID TEXT UNIQUE,
        fullName TEXT,
        gender TEXT,
        dateOfBirth TEXT,
        nationality TEXT,
        address TEXT,
        qualification TEXT,
        otherQualification TEXT,
        phone TEXT,
        email TEXT,
        role TEXT,
        username TEXT,
        password TEXT,
        accountStatus TEXT,
        profileImage TEXT,
        qualificationDocument TEXT,
        createdDate TEXT
      )
    ''');

    await db.execute('''
CREATE TABLE staff_documents(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  staffID TEXT,
  documentType TEXT,
  documentName TEXT,
  filePath TEXT,
  uploadDate TEXT
)
''');


  }

Future<void> _onUpgrade(
  Database db,
  int oldVersion,
  int newVersion,
) async {

  if (oldVersion < 3) {

    await db.execute('''
    CREATE TABLE IF NOT EXISTS staff_documents(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      staffID TEXT,
      documentType TEXT,
      documentName TEXT,
      filePath TEXT,
      uploadDate TEXT
    )
    ''');

  }
}

  Future<int> insertStaff(
    Map<String, dynamic> staff,
  ) async {

    final db = await database;


    return await db.insert(
      'staff',
      staff,
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );

  }



  Future<List<Map<String, dynamic>>> getStaff() async {

    final db = await database;


    return await db.query(
      'staff',
      orderBy: 'id DESC',
    );

  }



  Future<int> deleteStaff(
    String staffID,
  ) async {

    final db = await database;


    return await db.delete(
      'staff',
      where: 'staffID = ?',
      whereArgs: [
        staffID,
      ],
    );

  }

Future<int> updateStaff(
  Map<String, dynamic> staff,
) async {

  final db = await database;

  return await db.update(
    'staff',
    staff,
    where: 'staffID = ?',
    whereArgs: [
      staff['staffID'],
    ],
  );

}

Future<int> insertDocument(
  Map<String, dynamic> document,
) async {

  final db = await database;

  return await db.insert(
    'staff_documents',
    document,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

}

Future<List<Map<String, dynamic>>> getDocuments(
  String staffID,
) async {

  final db = await database;

  return await db.query(
    'staff_documents',
    where: 'staffID = ?',
    whereArgs: [staffID],
    orderBy: 'id DESC',
  );

}
Future<int> deleteDocument(
  int id,
) async {

  final db = await database;

  return await db.delete(
    'staff_documents',
    where: 'id = ?',
    whereArgs: [id],
  );

}
}