import 'package:path/path.dart' as path;
import 'package:sqflite_common/sqlite_api.dart';

import 'database_factory.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance =
      DatabaseHelper._();

  Database? _database;

  // ============================================================
  // DATABASE
  // ============================================================

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = path.join(
      'championone',
      'championone.db',
    );

    return championDatabaseFactory.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        // --------------------------------------------------------
        // VERSION 7
        //
        // Version 5 = biometric fields
        // Version 6 = parent/guardian photo
        // Version 7 = student documents table
        // --------------------------------------------------------

        version: 7,

        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
  }

  // ============================================================
  // DATABASE CREATION
  // ============================================================

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    // ----------------------------------------------------------
    // STAFF
    // ----------------------------------------------------------

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

    // ----------------------------------------------------------
    // STAFF DOCUMENTS
    // ----------------------------------------------------------

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

    // ----------------------------------------------------------
    // STUDENTS
    // ----------------------------------------------------------

    await db.execute('''
      CREATE TABLE students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentID TEXT UNIQUE,

        fullName TEXT,
        preferredName TEXT,
        dateOfBirth TEXT,
        gender TEXT,
        nationality TEXT,
        address TEXT,
        phone TEXT,

        schoolType TEXT,
        admissionCategory TEXT,
        academicYear TEXT,
        admissionDate TEXT,
        studentStatus TEXT,

        classGrade TEXT,

        previousSchool TEXT,
        previousGrade TEXT,
        previousAcademicYear TEXT,

        faculty TEXT,
        department TEXT,
        program TEXT,
        major TEXT,
        trainingLevel TEXT,
        practicalExperience TEXT,

        parentGuardianName TEXT,
        parentGuardianRelationship TEXT,
        parentGuardianPhone TEXT,
        parentGuardianEmail TEXT,
        parentGuardianAddress TEXT,
        parentGuardianOccupation TEXT,

        parentPhoto TEXT,

        emergencyContactName TEXT,
        emergencyContactPhone TEXT,

        studentPhoto TEXT,

        transcriptDocument TEXT,
        recommendationDocument TEXT,
        transferCertificate TEXT,
        otherDocuments TEXT,

        biometricStatus TEXT,
        biometricReference TEXT,
        biometricProvider TEXT,
        biometricEnrolledDate TEXT
      )
    ''');

    // ----------------------------------------------------------
    // STUDENT DOCUMENTS
    // ----------------------------------------------------------

    await db.execute('''
      CREATE TABLE student_documents(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentID TEXT,
        documentType TEXT,
        documentName TEXT,
        filePath TEXT,
        uploadDate TEXT
      )
    ''');
  }

  // ============================================================
  // DATABASE UPGRADE
  // ============================================================

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // ----------------------------------------------------------
    // VERSION 3
    // Adds staff_documents
    // ----------------------------------------------------------

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

    // ----------------------------------------------------------
    // VERSION 4
    // Adds students
    // ----------------------------------------------------------

    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS students(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          studentID TEXT UNIQUE,

          fullName TEXT,
          preferredName TEXT,
          dateOfBirth TEXT,
          gender TEXT,
          nationality TEXT,
          address TEXT,
          phone TEXT,

          schoolType TEXT,
          admissionCategory TEXT,
          academicYear TEXT,
          admissionDate TEXT,
          studentStatus TEXT,

          classGrade TEXT,

          previousSchool TEXT,
          previousGrade TEXT,
          previousAcademicYear TEXT,

          faculty TEXT,
          department TEXT,
          program TEXT,
          major TEXT,
          trainingLevel TEXT,
          practicalExperience TEXT,

          parentGuardianName TEXT,
          parentGuardianRelationship TEXT,
          parentGuardianPhone TEXT,
          parentGuardianEmail TEXT,
          parentGuardianAddress TEXT,
          parentGuardianOccupation TEXT,

          emergencyContactName TEXT,
          emergencyContactPhone TEXT,

          studentPhoto TEXT,

          transcriptDocument TEXT,
          recommendationDocument TEXT,
          transferCertificate TEXT,
          otherDocuments TEXT
        )
      ''');
    }

    // ----------------------------------------------------------
    // VERSION 5
    // Adds biometric fields
    // ----------------------------------------------------------

    if (oldVersion < 5) {
      await db.execute('''
        ALTER TABLE students
        ADD COLUMN biometricStatus TEXT
        DEFAULT 'Not Enrolled'
      ''');

      await db.execute('''
        ALTER TABLE students
        ADD COLUMN biometricReference TEXT
        DEFAULT ''
      ''');

      await db.execute('''
        ALTER TABLE students
        ADD COLUMN biometricProvider TEXT
        DEFAULT ''
      ''');

      await db.execute('''
        ALTER TABLE students
        ADD COLUMN biometricEnrolledDate TEXT
        DEFAULT ''
      ''');
    }

    // ----------------------------------------------------------
    // VERSION 6
    // Adds parent/guardian photo
    // ----------------------------------------------------------

    if (oldVersion < 6) {
      await db.execute('''
        ALTER TABLE students
        ADD COLUMN parentPhoto TEXT
        DEFAULT ''
      ''');
    }

    // ----------------------------------------------------------
    // VERSION 7
    // Adds student_documents table
    // ----------------------------------------------------------

    if (oldVersion < 7) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS student_documents(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          studentID TEXT,
          documentType TEXT,
          documentName TEXT,
          filePath TEXT,
          uploadDate TEXT
        )
      ''');

      // --------------------------------------------------------
      // MIGRATE EXISTING STUDENT DOCUMENTS
      // --------------------------------------------------------

      await db.execute('''
        INSERT INTO student_documents(
          studentID,
          documentType,
          documentName,
          filePath,
          uploadDate
        )
        SELECT
          studentID,
          'Transcript / Academic Record',
          transcriptDocument,
          transcriptDocument,
          admissionDate
        FROM students
        WHERE transcriptDocument IS NOT NULL
          AND transcriptDocument != ''
      ''');

      await db.execute('''
        INSERT INTO student_documents(
          studentID,
          documentType,
          documentName,
          filePath,
          uploadDate
        )
        SELECT
          studentID,
          'Letter of Recommendation',
          recommendationDocument,
          recommendationDocument,
          admissionDate
        FROM students
        WHERE recommendationDocument IS NOT NULL
          AND recommendationDocument != ''
      ''');

      await db.execute('''
        INSERT INTO student_documents(
          studentID,
          documentType,
          documentName,
          filePath,
          uploadDate
        )
        SELECT
          studentID,
          'Transfer Certificate',
          transferCertificate,
          transferCertificate,
          admissionDate
        FROM students
        WHERE transferCertificate IS NOT NULL
          AND transferCertificate != ''
      ''');

      await db.execute('''
        INSERT INTO student_documents(
          studentID,
          documentType,
          documentName,
          filePath,
          uploadDate
        )
        SELECT
          studentID,
          'Other Document',
          otherDocuments,
          otherDocuments,
          admissionDate
        FROM students
        WHERE otherDocuments IS NOT NULL
          AND otherDocuments != ''
      ''');
    }
  }

  // ============================================================
  // STAFF
  // ============================================================

  Future<int> insertStaff(
    Map<String, dynamic> staff,
  ) async {
    final db = await database;

    return db.insert(
      'staff',
      staff,
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getStaff() async {
    final db = await database;

    return db.query(
      'staff',
      orderBy: 'id DESC',
    );
  }

  Future<int> updateStaff(
    Map<String, dynamic> staff,
  ) async {
    final db = await database;

    return db.update(
      'staff',
      staff,
      where: 'staffID = ?',
      whereArgs: [
        staff['staffID'],
      ],
    );
  }

  Future<int> deleteStaff(
    String staffID,
  ) async {
    final db = await database;

    return db.delete(
      'staff',
      where: 'staffID = ?',
      whereArgs: [
        staffID,
      ],
    );
  }

  // ============================================================
  // STAFF DOCUMENTS
  // ============================================================

  Future<int> insertDocument(
    Map<String, dynamic> document,
  ) async {
    final db = await database;

    return db.insert(
      'staff_documents',
      document,
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getDocuments(
    String staffID,
  ) async {
    final db = await database;

    return db.query(
      'staff_documents',
      where: 'staffID = ?',
      whereArgs: [
        staffID,
      ],
      orderBy: 'id DESC',
    );
  }

  Future<int> deleteDocument(
    int id,
  ) async {
    final db = await database;

    return db.delete(
      'staff_documents',
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }

  // ============================================================
  // STUDENTS
  // ============================================================

  Future<int> insertStudent(
    Map<String, dynamic> student,
  ) async {
    final db = await database;

    return db.insert(
      'students',
      student,
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final db = await database;

    return db.query(
      'students',
      orderBy: 'id DESC',
    );
  }

  Future<Map<String, dynamic>?> getStudentByID(
    String studentID,
  ) async {
    final db = await database;

    final results = await db.query(
      'students',
      where: 'studentID = ?',
      whereArgs: [
        studentID,
      ],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return results.first;
  }

  Future<int> updateStudent(
    Map<String, dynamic> student,
  ) async {
    final db = await database;

    return db.update(
      'students',
      student,
      where: 'studentID = ?',
      whereArgs: [
        student['studentID'],
      ],
    );
  }

  Future<int> deleteStudent(
    String studentID,
  ) async {
    final db = await database;

    return db.delete(
      'students',
      where: 'studentID = ?',
      whereArgs: [
        studentID,
      ],
    );
  }

  // ============================================================
  // STUDENT DOCUMENTS
  // ============================================================

  Future<int> insertStudentDocument(
    Map<String, dynamic> document,
  ) async {
    final db = await database;

    return db.insert(
      'student_documents',
      document,
    );
  }

  Future<List<Map<String, dynamic>>>
      getStudentDocuments(
    String studentID,
  ) async {
    final db = await database;

    return db.query(
      'student_documents',
      where: 'studentID = ?',
      whereArgs: [
        studentID,
      ],
      orderBy: 'id DESC',
    );
  }

  Future<int> updateStudentDocument(
    Map<String, dynamic> document,
  ) async {
    final db = await database;

    return db.update(
      'student_documents',
      document,
      where: 'id = ?',
      whereArgs: [
        document['id'],
      ],
    );
  }

  Future<int> deleteStudentDocument(
    int id,
  ) async {
    final db = await database;

    return db.delete(
      'student_documents',
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }
}