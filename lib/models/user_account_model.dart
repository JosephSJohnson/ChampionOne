class UserAccount {
  final int id;
  final String accountId;
  final int schoolId;
  final String displayName;
  final String displayTitle;
  final String systemRole;
  final String username;
  final String email;
  final String phone;
  final String accountStatus;
  final String createdAt;
  final String? lastLoginAt;

  const UserAccount({
    required this.id,
    required this.accountId,
    required this.schoolId,
    required this.displayName,
    required this.displayTitle,
    required this.systemRole,
    required this.username,
    required this.email,
    required this.phone,
    required this.accountStatus,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory UserAccount.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserAccount(
      id: int.tryParse(
            '${map['id']}',
          ) ??
          0,
      accountId:
          '${map['accountId'] ?? ''}',
      schoolId: int.tryParse(
            '${map['schoolId']}',
          ) ??
          0,
      displayName:
          '${map['displayName'] ?? ''}',
      displayTitle:
          '${map['displayTitle'] ?? ''}',
      systemRole:
          '${map['systemRole'] ?? ''}',
      username:
          '${map['username'] ?? ''}',
      email:
          '${map['email'] ?? ''}',
      phone:
          '${map['phone'] ?? ''}',
      accountStatus:
          '${map['accountStatus'] ?? ''}',
      createdAt:
          '${map['createdAt'] ?? ''}',
      lastLoginAt:
          map['lastLoginAt']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountId': accountId,
      'schoolId': schoolId,
      'displayName': displayName,
      'displayTitle': displayTitle,
      'systemRole': systemRole,
      'username': username,
      'email': email,
      'phone': phone,
      'accountStatus': accountStatus,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
    };
  }
}