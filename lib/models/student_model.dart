class StudentModel {
  final int? id;

  final String studentID;
  final String fullName;
  final String preferredName;
  final String dateOfBirth;
  final String gender;
  final String nationality;
  final String address;
  final String phone;

  final String schoolType;
  final String admissionCategory;
  final String academicYear;
  final String admissionDate;
  final String studentStatus;

  final String classGrade;

  final String previousSchool;
  final String previousGrade;
  final String previousAcademicYear;

  final String faculty;
  final String department;
  final String program;
  final String major;
  final String trainingLevel;
  final String practicalExperience;

  final String parentGuardianName;
  final String parentGuardianRelationship;
  final String parentGuardianPhone;
  final String parentGuardianEmail;
  final String parentGuardianAddress;
  final String parentGuardianOccupation;

  final String emergencyContactName;
  final String emergencyContactPhone;

  final String studentPhoto;

  final String transcriptDocument;
  final String recommendationDocument;
  final String transferCertificate;
  final String otherDocuments;

  const StudentModel({
    this.id,
    required this.studentID,
    required this.fullName,
    required this.preferredName,
    required this.dateOfBirth,
    required this.gender,
    required this.nationality,
    required this.address,
    required this.phone,
    required this.schoolType,
    required this.admissionCategory,
    required this.academicYear,
    required this.admissionDate,
    required this.studentStatus,
    required this.classGrade,
    required this.previousSchool,
    required this.previousGrade,
    required this.previousAcademicYear,
    required this.faculty,
    required this.department,
    required this.program,
    required this.major,
    required this.trainingLevel,
    required this.practicalExperience,
    required this.parentGuardianName,
    required this.parentGuardianRelationship,
    required this.parentGuardianPhone,
    required this.parentGuardianEmail,
    required this.parentGuardianAddress,
    required this.parentGuardianOccupation,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.studentPhoto,
    required this.transcriptDocument,
    required this.recommendationDocument,
    required this.transferCertificate,
    required this.otherDocuments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentID': studentID,
      'fullName': fullName,
      'preferredName': preferredName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'nationality': nationality,
      'address': address,
      'phone': phone,
      'schoolType': schoolType,
      'admissionCategory': admissionCategory,
      'academicYear': academicYear,
      'admissionDate': admissionDate,
      'studentStatus': studentStatus,
      'classGrade': classGrade,
      'previousSchool': previousSchool,
      'previousGrade': previousGrade,
      'previousAcademicYear': previousAcademicYear,
      'faculty': faculty,
      'department': department,
      'program': program,
      'major': major,
      'trainingLevel': trainingLevel,
      'practicalExperience': practicalExperience,
      'parentGuardianName': parentGuardianName,
      'parentGuardianRelationship':
          parentGuardianRelationship,
      'parentGuardianPhone':
          parentGuardianPhone,
      'parentGuardianEmail':
          parentGuardianEmail,
      'parentGuardianAddress':
          parentGuardianAddress,
      'parentGuardianOccupation':
          parentGuardianOccupation,
      'emergencyContactName':
          emergencyContactName,
      'emergencyContactPhone':
          emergencyContactPhone,
      'studentPhoto': studentPhoto,
      'transcriptDocument':
          transcriptDocument,
      'recommendationDocument':
          recommendationDocument,
      'transferCertificate':
          transferCertificate,
      'otherDocuments':
          otherDocuments,
    };
  }

  factory StudentModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return StudentModel(
      id: map['id'] as int?,
      studentID: map['studentID'] ?? '',
      fullName: map['fullName'] ?? '',
      preferredName: map['preferredName'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      gender: map['gender'] ?? '',
      nationality: map['nationality'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      schoolType: map['schoolType'] ?? '',
      admissionCategory:
          map['admissionCategory'] ?? '',
      academicYear:
          map['academicYear'] ?? '',
      admissionDate:
          map['admissionDate'] ?? '',
      studentStatus:
          map['studentStatus'] ?? '',
      classGrade:
          map['classGrade'] ?? '',
      previousSchool:
          map['previousSchool'] ?? '',
      previousGrade:
          map['previousGrade'] ?? '',
      previousAcademicYear:
          map['previousAcademicYear'] ?? '',
      faculty:
          map['faculty'] ?? '',
      department:
          map['department'] ?? '',
      program:
          map['program'] ?? '',
      major:
          map['major'] ?? '',
      trainingLevel:
          map['trainingLevel'] ?? '',
      practicalExperience:
          map['practicalExperience'] ?? '',
      parentGuardianName:
          map['parentGuardianName'] ?? '',
      parentGuardianRelationship:
          map['parentGuardianRelationship'] ?? '',
      parentGuardianPhone:
          map['parentGuardianPhone'] ?? '',
      parentGuardianEmail:
          map['parentGuardianEmail'] ?? '',
      parentGuardianAddress:
          map['parentGuardianAddress'] ?? '',
      parentGuardianOccupation:
          map['parentGuardianOccupation'] ?? '',
      emergencyContactName:
          map['emergencyContactName'] ?? '',
      emergencyContactPhone:
          map['emergencyContactPhone'] ?? '',
      studentPhoto:
          map['studentPhoto'] ?? '',
      transcriptDocument:
          map['transcriptDocument'] ?? '',
      recommendationDocument:
          map['recommendationDocument'] ?? '',
      transferCertificate:
          map['transferCertificate'] ?? '',
      otherDocuments:
          map['otherDocuments'] ?? '',
    );
  }
}