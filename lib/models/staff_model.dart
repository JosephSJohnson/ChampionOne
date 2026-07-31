class StaffModel {
  final String staffID;
  final String profileImage;
  final String qualificationDocument;

  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String nationality;
  final String address;

  final String qualification;
  final String otherQualification;

  final String phone;
  final String email;

  final String role;

  final String username;
  final String password;

  final String accountStatus;

  final DateTime createdDate;

  const StaffModel({
    required this.staffID,
    required this.profileImage,
    required this.qualificationDocument,

    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.nationality,
    required this.address,

    required this.qualification,
    required this.otherQualification,

    required this.phone,
    required this.email,

    required this.role,

    required this.username,
    required this.password,

    required this.accountStatus,

    required this.createdDate,
  });

    factory StaffModel.fromMap(
    Map<String, dynamic> map,
  ) {

    return StaffModel(

      staffID:
          map['staffID'] ?? "",

      profileImage:
          map['profileImage'] ?? "",

      qualificationDocument:
          map['qualificationDocument'] ?? "",


      fullName:
          map['fullName'] ?? "",

      dateOfBirth:
          map['dateOfBirth'] ?? "",

      gender:
          map['gender'] ?? "",

      nationality:
          map['nationality'] ?? "",

      address:
          map['address'] ?? "",


      qualification:
          map['qualification'] ?? "",

      otherQualification:
          map['otherQualification'] ?? "",


      phone:
          map['phone'] ?? "",

      email:
          map['email'] ?? "",


      role:
          map['role'] ?? "",


      username:
          map['username'] ?? "",

      password:
          map['password'] ?? "",


      accountStatus:
          map['accountStatus'] ?? "",


      createdDate:
          DateTime.parse(
            map['createdDate'],
          ),

    );

  }

  Map<String, dynamic> toMap() {

    return {

      "staffID": staffID,

      "profileImage": profileImage,

      "qualificationDocument":
          qualificationDocument,

      "fullName": fullName,

      "dateOfBirth": dateOfBirth,

      "gender": gender,

      "nationality": nationality,

      "address": address,

      "qualification": qualification,

      "otherQualification":
          otherQualification,

      "phone": phone,

      "email": email,

      "role": role,

      "username": username,

      "password": password,

      "accountStatus":
          accountStatus,

      "createdDate":
          createdDate.toIso8601String(),

    };

  }

}
