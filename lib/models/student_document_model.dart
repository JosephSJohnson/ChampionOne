class StudentDocumentModel {
  final int? id;

  final String studentID;
  final String documentType;
  final String documentName;
  final String filePath;
  final String uploadDate;

  const StudentDocumentModel({
    this.id,
    required this.studentID,
    required this.documentType,
    required this.documentName,
    required this.filePath,
    required this.uploadDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentID': studentID,
      'documentType': documentType,
      'documentName': documentName,
      'filePath': filePath,
      'uploadDate': uploadDate,
    };
  }

  factory StudentDocumentModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return StudentDocumentModel(
      id: map['id'] as int?,
      studentID:
          map['studentID'] ?? '',
      documentType:
          map['documentType'] ?? '',
      documentName:
          map['documentName'] ?? '',
      filePath:
          map['filePath'] ?? '',
      uploadDate:
          map['uploadDate'] ?? '',
    );
  }
}