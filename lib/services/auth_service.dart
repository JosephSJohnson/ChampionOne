import '../database/database_helper.dart';
import '../models/user_account_model.dart';
import '../security/password_hasher.dart';

class AuthService {
  AuthService._();

  static final AuthService instance =
      AuthService._();

  // ============================================================
  // LOGIN
  // ============================================================

  Future<UserAccount> login({
    required int schoolId,
    required String username,
    required String password,
  }) async {
    final normalizedUsername =
        username.trim().toLowerCase();

    if (normalizedUsername.isEmpty) {
      throw Exception(
        'Username is required.',
      );
    }

    if (password.isEmpty) {
      throw Exception(
        'Password is required.',
      );
    }

    final account =
        await DatabaseHelper.instance
            .getUserAccountByUsername(
      schoolId,
      normalizedUsername,
    );

    if (account == null) {
      throw Exception(
        'Invalid username or password.',
      );
    }

    final accountStatus =
        '${account['accountStatus'] ?? ''}'
            .trim()
            .toLowerCase();

    if (accountStatus != 'active') {
      throw Exception(
        'This account is not active. Please contact the school administrator.',
      );
    }

    final storedHash =
        '${account['passwordHash'] ?? ''}';

    final storedSalt =
        '${account['passwordSalt'] ?? ''}';

    final passwordMatches =
        await PasswordHasher.verifyPassword(
      password: password,
      storedHash: storedHash,
      storedSalt: storedSalt,
    );

    if (!passwordMatches) {
      throw Exception(
        'Invalid username or password.',
      );
    }

    final accountDatabaseId =
        int.tryParse(
      '${account['id']}',
    );

    if (accountDatabaseId == null) {
      throw Exception(
        'The user account has an invalid database ID.',
      );
    }

    await DatabaseHelper.instance
        .updateUserAccountLastLogin(
      accountDatabaseId,
    );

    final updatedAccount =
        Map<String, dynamic>.from(
      account,
    );

    updatedAccount['lastLoginAt'] =
        DateTime.now().toIso8601String();

    return UserAccount.fromMap(
      updatedAccount,
    );
  }
}