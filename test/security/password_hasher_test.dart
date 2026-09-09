import 'package:flutter_test/flutter_test.dart';

import 'package:championone/security/password_hasher.dart';

void main() {
  group('PasswordHasher', () {
    test('creates a password hash and verifies the correct password', () async {
      const password = 'ChampionOne@2026';

      final result =
          await PasswordHasher.hashPassword(password);

      expect(result.hash, isNotEmpty);
      expect(result.salt, isNotEmpty);

      final verified =
          await PasswordHasher.verifyPassword(
        password: password,
        storedHash: result.hash,
        storedSalt: result.salt,
      );

      expect(verified, isTrue);
    });

    test('rejects an incorrect password', () async {
      const password = 'ChampionOne@2026';

      final result =
          await PasswordHasher.hashPassword(password);

      final verified =
          await PasswordHasher.verifyPassword(
        password: 'WrongPassword@2026',
        storedHash: result.hash,
        storedSalt: result.salt,
      );

      expect(verified, isFalse);
    });

    test('generates different salts for separate hashes', () async {
      const password = 'ChampionOne@2026';

      final first =
          await PasswordHasher.hashPassword(password);

      final second =
          await PasswordHasher.hashPassword(password);

      expect(first.salt, isNot(second.salt));
      expect(first.hash, isNot(second.hash));
    });
  });
}