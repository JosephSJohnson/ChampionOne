import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

class PasswordHashResult {
  final String hash;
  final String salt;

  const PasswordHashResult({
    required this.hash,
    required this.salt,
  });
}

/// ChampionOne password hashing service.
///
/// Passwords are never stored as plaintext.
/// Argon2id is used to derive a secure password hash.
class PasswordHasher {
  PasswordHasher._();

  // Argon2id parameters.
  //
  // memory is measured in KiB.
  // 19,456 KiB is approximately 19 MiB.
  static const int memory = 19456;
  static const int parallelism = 1;
  static const int iterations = 2;
  static const int hashLength = 32;

  // 16 bytes provides a strong unique salt.
  static const int saltLength = 16;

  static final Argon2id _algorithm = Argon2id(
    memory: memory,
    parallelism: parallelism,
    iterations: iterations,
    hashLength: hashLength,
  );

  static final Random _secureRandom = Random.secure();

  /// Generates a cryptographically secure random salt.
  static List<int> _generateSalt() {
    return List<int>.generate(
      saltLength,
      (_) => _secureRandom.nextInt(256),
    );
  }

  /// Hashes a password using Argon2id and a new random salt.
  static Future<PasswordHashResult> hashPassword(
    String password,
  ) async {
    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty.');
    }

    final salt = _generateSalt();

    final secretKey =
        await _algorithm.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );

    final hashBytes =
        await secretKey.extractBytes();

    return PasswordHashResult(
      hash: base64UrlEncode(hashBytes),
      salt: base64UrlEncode(salt),
    );
  }

  /// Verifies a password against a previously stored
  /// Argon2id hash and salt.
  static Future<bool> verifyPassword({
    required String password,
    required String storedHash,
    required String storedSalt,
  }) async {
    if (password.isEmpty ||
        storedHash.isEmpty ||
        storedSalt.isEmpty) {
      return false;
    }

    try {
      final salt =
          base64Url.decode(storedSalt);

      final expectedHash =
          base64Url.decode(storedHash);

      final secretKey =
          await _algorithm.deriveKeyFromPassword(
        password: password,
        nonce: salt,
      );

      final actualHash =
          await secretKey.extractBytes();

      return _constantTimeEquals(
        actualHash,
        expectedHash,
      );
    } catch (_) {
      return false;
    }
  }

  /// Compares two byte arrays without returning
  /// early when a mismatch is found.
  static bool _constantTimeEquals(
    List<int> a,
    List<int> b,
  ) {
    if (a.length != b.length) {
      return false;
    }

    var difference = 0;

    for (var i = 0; i < a.length; i++) {
      difference |= a[i] ^ b[i];
    }

    return difference == 0;
  }
}