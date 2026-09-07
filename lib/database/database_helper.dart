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
        // VERSION HISTORY
        //
        // Version 5 = biometric fields
        // Version 6 = parent/guardian photo
        // Version 7 = student documents table
        // Version 8 = academic years table
        // Version 9 = academic terms table
        // Version 10 = system settings / installation state
        // Version 11 = permanent school record
        // Version 12 = leadership roles and stable system roles
        // --------------------------------------------------------

        version: 12,
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

    // ----------------------------------------------------------
    // ACADEMIC YEARS
    // ----------------------------------------------------------

    await db.execute('''
      CREATE TABLE academic_years(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        academicYear TEXT UNIQUE,
        openingDate TEXT,
        closingDate TEXT,
        numberOfTerms TEXT,
        status TEXT,
        isCurrent INTEGER DEFAULT 0,
        createdAt TEXT
      )
    ''');

    // ----------------------------------------------------------
    // ACADEMIC TERMS
    // ----------------------------------------------------------

    await db.execute('''
      CREATE TABLE academic_terms(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        academicYearId INTEGER NOT NULL,
        termNumber INTEGER NOT NULL,
        termName TEXT NOT NULL,
        startDate TEXT,
        endDate TEXT,
        status TEXT,
        UNIQUE(academicYearId, termNumber)
      )
    ''');

    // ----------------------------------------------------------
// LEADERSHIP ROLES
// Version 12
// ----------------------------------------------------------

await db.execute('''
  CREATE TABLE leadership_roles(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    schoolId INTEGER NOT NULL,
    systemRole TEXT NOT NULL,
    displayTitle TEXT NOT NULL,
    isEnabled INTEGER NOT NULL DEFAULT 1,
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL,
    UNIQUE(schoolId, systemRole)
  )
''');

    await db.execute('''
      CREATE TABLE schools(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        schoolCode TEXT UNIQUE NOT NULL,
        schoolName TEXT NOT NULL,
        schoolType TEXT,
        location TEXT,
        phone TEXT,
        email TEXT,
        status TEXT NOT NULL DEFAULT 'Active',
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // ----------------------------------------------------------
    // SYSTEM SETTINGS
    // Version 10
    // ----------------------------------------------------------

    await db.execute('''
      CREATE TABLE system_settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        setupCompleted INTEGER NOT NULL DEFAULT 0,
        schoolId INTEGER,
        currentAcademicYearId INTEGER,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    // ----------------------------------------------------------
    // DEFAULT SYSTEM SETTINGS ROW
    // ----------------------------------------------------------

    await db.insert(
      'system_settings',
      {
        'setupCompleted': 0,
        'schoolId': null,
        'currentAcademicYearId': null,
        'createdAt':
            DateTime.now().toIso8601String(),
        'updatedAt':
            DateTime.now().toIso8601String(),
      },
    );
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

    // ----------------------------------------------------------
    // VERSION 8
    // Adds academic_years table
    // ----------------------------------------------------------

    if (oldVersion < 8) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS academic_years(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          academicYear TEXT UNIQUE,
          openingDate TEXT,
          closingDate TEXT,
          numberOfTerms TEXT,
          status TEXT,
          isCurrent INTEGER DEFAULT 0,
          createdAt TEXT
        )
      ''');
    }

    // ----------------------------------------------------------
    // VERSION 9
    // Adds academic_terms table
    // ----------------------------------------------------------

    if (oldVersion < 9) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS academic_terms(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          academicYearId INTEGER NOT NULL,
          termNumber INTEGER NOT NULL,
          termName TEXT NOT NULL,
          startDate TEXT,
          endDate TEXT,
          status TEXT,
          UNIQUE(academicYearId, termNumber)
        )
      ''');
    }

    // ----------------------------------------------------------
    // VERSION 10
    // Adds system_settings table
    // ----------------------------------------------------------

    if (oldVersion < 10) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS system_settings(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          setupCompleted INTEGER NOT NULL DEFAULT 0,
          schoolId INTEGER,
          currentAcademicYearId INTEGER,
          createdAt TEXT,
          updatedAt TEXT
        )
      ''');

      final existingSettings = await db.query(
        'system_settings',
        limit: 1,
      );

      if (existingSettings.isEmpty) {
        final now =
            DateTime.now().toIso8601String();

        await db.insert(
          'system_settings',
          {
            'setupCompleted': 0,
            'schoolId': null,
            'currentAcademicYearId':
                null,
            'createdAt': now,
            'updatedAt': now,
          },
        );
      }
    }

    // ----------------------------------------------------------
    // VERSION 11
    // Adds permanent school record
    // ----------------------------------------------------------

    if (oldVersion < 11) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS schools(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          schoolCode TEXT UNIQUE NOT NULL,
          schoolName TEXT NOT NULL,
          schoolType TEXT,
          location TEXT,
          phone TEXT,
          email TEXT,
          status TEXT NOT NULL DEFAULT 'Active',
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');
    }

    // ----------------------------------------------------------
// VERSION 12
// Adds leadership_roles table
// ----------------------------------------------------------

if (oldVersion < 12) {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS leadership_roles(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      schoolId INTEGER NOT NULL,
      systemRole TEXT NOT NULL,
      displayTitle TEXT NOT NULL,
      isEnabled INTEGER NOT NULL DEFAULT 1,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      UNIQUE(schoolId, systemRole)
    )
  ''');
}
  }

  // ============================================================
  // SCHOOL MANAGEMENT
  // ============================================================

  Future<int> createSchool(
    Map<String, dynamic> school,
  ) async {
    final db = await database;

    final schoolName =
        (school['schoolName'] ?? '')
            .toString()
            .trim();

    if (schoolName.isEmpty) {
      throw Exception(
        'School name is required.',
      );
    }

    final existingSchools =
        await db.query(
      'schools',
      limit: 1,
    );

    // ----------------------------------------------------------
    // ChampionOne local installation currently represents one
    // school. A future cloud version will support many schools.
    // ----------------------------------------------------------

    if (existingSchools.isNotEmpty) {
      return existingSchools.first['id'] as int;
    }

    final now =
        DateTime.now().toIso8601String();

    final schoolCode =
        _generateSchoolCode();

    return db.transaction<int>(
      (txn) async {
        final schoolData =
            Map<String, dynamic>.from(
          school,
        );

        schoolData['schoolCode'] =
            schoolData['schoolCode'] ??
                schoolCode;

        schoolData['schoolName'] =
            schoolName;

        schoolData['schoolType'] =
            (school['schoolType'] ?? '')
                .toString()
                .trim();

        schoolData['location'] =
            (school['location'] ?? '')
                .toString()
                .trim();

        schoolData['phone'] =
            (school['phone'] ?? '')
                .toString()
                .trim();

        schoolData['email'] =
            (school['email'] ?? '')
                .toString()
                .trim();

        schoolData['status'] =
            school['status'] ?? 'Active';

        schoolData['createdAt'] =
            school['createdAt'] ?? now;

        schoolData['updatedAt'] =
            now;

        final schoolId =
            await txn.insert(
          'schools',
          schoolData,
        );

        // ------------------------------------------------------
        // Save the school ID into system settings.
        // ------------------------------------------------------

        final settings =
            await txn.query(
          'system_settings',
          orderBy: 'id ASC',
          limit: 1,
        );

        if (settings.isNotEmpty) {
          await txn.update(
            'system_settings',
            {
              'schoolId': schoolId,
              'updatedAt': now,
            },
            where: 'id = ?',
            whereArgs: [
              settings.first['id'],
            ],
          );
        }

        return schoolId;
      },
    );
  }

  String _generateSchoolCode() {
    final now = DateTime.now();

    final year =
        now.year.toString();

    final month =
        now.month.toString().padLeft(2, '0');

    final day =
        now.day.toString().padLeft(2, '0');

    final time =
        now.millisecondsSinceEpoch
            .toString()
            .substring(7);

    return 'SCH-$year$month$day-$time';
  }

  Future<List<Map<String, dynamic>>>
      getSchools() async {
    final db = await database;

    return db.query(
      'schools',
      orderBy: 'id ASC',
    );
  }

  Future<Map<String, dynamic>?>
      getSchoolById(
    int id,
  ) async {
    final db = await database;

    final results = await db.query(
      'schools',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return results.first;
  }

  Future<Map<String, dynamic>?>
      getCurrentSchool() async {
    final settings =
        await getSystemSettings();

    final schoolId =
        settings?['schoolId'];

    if (schoolId == null) {
      return null;
    }

    return getSchoolById(
      schoolId as int,
    );
  }

  // ============================================================
  // SYSTEM SETTINGS
  // ============================================================

  Future<Map<String, dynamic>?>
      getSystemSettings() async {
    final db = await database;

    final results = await db.query(
      'system_settings',
      orderBy: 'id ASC',
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return results.first;
  }

  Future<bool> isSetupCompleted() async {
    final settings =
        await getSystemSettings();

    if (settings == null) {
      return false;
    }

    return settings['setupCompleted'] == 1;
  }

  Future<void> markSetupCompleted({
    int? schoolId,
    int? currentAcademicYearId,
  }) async {
    final db = await database;

    final existing =
        await getSystemSettings();

    final now =
        DateTime.now().toIso8601String();

    if (existing == null) {
      await db.insert(
        'system_settings',
        {
          'setupCompleted': 1,
          'schoolId': schoolId,
          'currentAcademicYearId':
              currentAcademicYearId,
          'createdAt': now,
          'updatedAt': now,
        },
      );

      return;
    }

    await db.update(
      'system_settings',
      {
        'setupCompleted': 1,
        'schoolId': schoolId,
        'currentAcademicYearId':
            currentAcademicYearId,
        'updatedAt': now,
      },
      where: 'id = ?',
      whereArgs: [existing['id']],
    );
  }

  Future<void> setCurrentAcademicYearId(
    int academicYearId,
  ) async {
    final db = await database;

    final existing =
        await getSystemSettings();

    if (existing == null) {
      await db.insert(
        'system_settings',
        {
          'setupCompleted': 0,
          'schoolId': null,
          'currentAcademicYearId':
              academicYearId,
          'createdAt':
              DateTime.now()
                  .toIso8601String(),
          'updatedAt':
              DateTime.now()
                  .toIso8601String(),
        },
      );

      return;
    }

    await db.update(
      'system_settings',
      {
        'currentAcademicYearId':
            academicYearId,
        'updatedAt':
            DateTime.now()
                .toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [existing['id']],
    );
  }

  // ============================================================
  // ACADEMIC YEARS
  // ============================================================

  Future<int> createAcademicYear(
    Map<String, dynamic> academicYear,
  ) async {
    final db = await database;

    final yearName =
        (academicYear['academicYear'] ?? '')
            .toString()
            .trim();

    if (yearName.isEmpty) {
      throw Exception(
        'Academic year is required.',
      );
    }

    final existing = await db.query(
      'academic_years',
      where: 'academicYear = ?',
      whereArgs: [yearName],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      throw Exception(
        'Academic year $yearName already exists.',
      );
    }

    final now =
        DateTime.now().toIso8601String();

    return db.transaction<int>(
      (txn) async {
        await txn.update(
          'academic_years',
          {
            'status': 'Closed',
            'isCurrent': 0,
          },
          where: 'isCurrent = ?',
          whereArgs: [1],
        );

        final data =
            Map<String, dynamic>.from(
          academicYear,
        );

        data['academicYear'] =
            yearName;

        data['status'] =
            'Active';

        data['isCurrent'] =
            1;

        data['createdAt'] =
            data['createdAt'] ?? now;

        final academicYearId =
            await txn.insert(
          'academic_years',
          data,
        );

        final settings =
            await txn.query(
          'system_settings',
          orderBy: 'id ASC',
          limit: 1,
        );

        if (settings.isNotEmpty) {
          await txn.update(
            'system_settings',
            {
              'currentAcademicYearId':
                  academicYearId,
              'updatedAt': now,
            },
            where: 'id = ?',
            whereArgs: [
              settings.first['id'],
            ],
          );
        }

        return academicYearId;
      },
    );
  }

  Future<List<Map<String, dynamic>>>
      getAcademicYears() async {
    final db = await database;

    return db.query(
      'academic_years',
      orderBy:
          'isCurrent DESC, openingDate DESC, id DESC',
    );
  }

  Future<Map<String, dynamic>?>
      getCurrentAcademicYear() async {
    final db = await database;

    final results = await db.query(
      'academic_years',
      where: 'isCurrent = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return results.first;
  }

  Future<Map<String, dynamic>?>
      getAcademicYearByName(
    String academicYear,
  ) async {
    final db = await database;

    final results = await db.query(
      'academic_years',
      where: 'academicYear = ?',
      whereArgs: [
        academicYear.trim(),
      ],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return results.first;
  }

  // ============================================================
  // ACADEMIC TERMS
  // ============================================================

  Future<int> createAcademicTerm(
    Map<String, dynamic> term,
  ) async {
    final db = await database;

    final academicYearId =
        term['academicYearId'];

    if (academicYearId == null) {
      throw Exception(
        'Academic year is required.',
      );
    }

    final termNumber =
        term['termNumber'];

    if (termNumber == null) {
      throw Exception(
        'Term number is required.',
      );
    }

    final termName =
        (term['termName'] ?? '')
            .toString()
            .trim();

    if (termName.isEmpty) {
      throw Exception(
        'Term name is required.',
      );
    }

    final existing =
        await db.query(
      'academic_terms',
      where:
          'academicYearId = ? AND termNumber = ?',
      whereArgs: [
        academicYearId,
        termNumber,
      ],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      throw Exception(
        'This term already exists for the selected academic year.',
      );
    }

    return db.insert(
      'academic_terms',
      {
        'academicYearId':
            academicYearId,
        'termNumber':
            termNumber,
        'termName':
            termName,
        'startDate':
            term['startDate'] ?? '',
        'endDate':
            term['endDate'] ?? '',
        'status':
            term['status'] ?? 'Active',
      },
    );
  }

  Future<List<Map<String, dynamic>>>
      getAcademicTerms(
    int academicYearId,
  ) async {
    final db = await database;

    return db.query(
      'academic_terms',
      where:
          'academicYearId = ?',
      whereArgs: [
        academicYearId,
      ],
      orderBy:
          'termNumber ASC',
    );
  }

  Future<Map<String, dynamic>?>
      getAcademicTermById(
    int id,
  ) async {
    final db = await database;

    final results = await db.query(
      'academic_terms',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return results.first;
  }

  Future<int> updateAcademicTerm(
    Map<String, dynamic> term,
  ) async {
    final db = await database;

    final id =
        term['id'];

    if (id == null) {
      throw Exception(
        'Term ID is required.',
      );
    }

    return db.update(
      'academic_terms',
      term,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAcademicTerm(
    int id,
  ) async {
    final db = await database;

    return db.delete(
      'academic_terms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// ============================================================
// LEADERSHIP ROLES
// ============================================================

Future<void> saveLeadershipRoles(
  int schoolId,
  Map<String, String> roles,
) async {
  final db = await database;

  final now =
      DateTime.now().toIso8601String();

  await db.transaction(
    (txn) async {
      for (final entry in roles.entries) {
        await txn.insert(
          'leadership_roles',
          {
            'schoolId': schoolId,
            'systemRole': entry.key,
            'displayTitle': entry.value,
            'isEnabled': 1,
            'createdAt': now,
            'updatedAt': now,
          },
          conflictAlgorithm:
              ConflictAlgorithm.replace,
        );
      }
    },
  );
}

Future<List<Map<String, dynamic>>>
    getLeadershipRoles(
  int schoolId,
) async {
  final db = await database;

  return db.query(
    'leadership_roles',
    where: 'schoolId = ?',
    whereArgs: [schoolId],
    orderBy: 'id ASC',
  );
}

Future<Map<String, dynamic>?>
    getLeadershipRole(
  int schoolId,
  String systemRole,
) async {
  final db = await database;

  final results = await db.query(
    'leadership_roles',
    where:
        'schoolId = ? AND systemRole = ?',
    whereArgs: [
      schoolId,
      systemRole,
    ],
    limit: 1,
  );

  if (results.isEmpty) {
    return null;
  }

  return results.first;
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

  Future<List<Map<String, dynamic>>>
      getStaff() async {
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

  Future<List<Map<String, dynamic>>>
      getDocuments(
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

  Future<List<Map<String, dynamic>>>
      getStudents() async {
    final db = await database;

    return db.query(
      'students',
      orderBy: 'id DESC',
    );
  }

  Future<Map<String, dynamic>?>
      getStudentByID(
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