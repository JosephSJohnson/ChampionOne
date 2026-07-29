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
}