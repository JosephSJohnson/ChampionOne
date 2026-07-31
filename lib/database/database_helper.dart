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
      version: 1,
      onCreate: _onCreate,
    );

  }



  Future<void> _onCreate(
    Database db,
    int version,
  ) async {

    await db.execute('''
      CREATE TABLE staff(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        staffID TEXT,
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


}