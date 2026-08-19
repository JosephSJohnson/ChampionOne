class StaffDocumentModel {

  final int? id;

  final String staffID;

  final String documentType;

  final String documentName;

  final String filePath;

  final String uploadDate;


  StaffDocumentModel({

  this.id,

  required this.staffID,

  required this.documentType,

  required this.documentName,

  required this.filePath,

  required this.uploadDate,

});


  Map<String, dynamic> toMap() {

    return {

      'id': id,

      'staffID': staffID,

      'documentType': documentType,

      'documentName': documentName,

      'filePath': filePath,

      'uploadDate': uploadDate,

    };

  }


  factory StaffDocumentModel.fromMap(
  Map<String, dynamic> map,
) {

  return StaffDocumentModel(

    id: map['id'],

    staffID: map['staffID'],

    documentType: map['documentType'],

    documentName: map['documentName'],

    filePath: map['filePath'],

    uploadDate: map['uploadDate'],

  );

}

}