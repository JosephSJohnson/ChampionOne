import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import '../../security/password_hasher.dart';
import '../dashboard/proprietor_dashboard_screen.dart';

class AdminSetupScreen extends StatefulWidget {
  const AdminSetupScreen({
    super.key,
  });

  @override
  State<AdminSetupScreen> createState() =>
      _AdminSetupScreenState();
}

class _AdminSetupScreenState
    extends State<AdminSetupScreen> {
  final TextEditingController
      fullNameController =
      TextEditingController();

  final TextEditingController
      phoneController =
      TextEditingController();

  final TextEditingController
      emailController =
      TextEditingController();

  final TextEditingController
      usernameController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  final TextEditingController
      confirmPasswordController =
      TextEditingController();

  bool isSaving = false;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  String? _validateForm() {
    final fullName =
        fullNameController.text.trim();

    final username =
        usernameController.text.trim();

    final password =
        passwordController.text;

    final confirmPassword =
        confirmPasswordController.text;

    if (fullName.isEmpty) {
      return "Full Name is required.";
    }

    if (username.isEmpty) {
      return "Username is required.";
    }

    if (username.length < 4) {
      return "Username must contain at least 4 characters.";
    }

    if (!RegExp(
      r'^[a-zA-Z0-9._-]+$',
    ).hasMatch(username)) {
      return "Username may contain only letters, numbers, dots, underscores, and hyphens.";
    }

    if (password.isEmpty) {
      return "Password is required.";
    }

    if (password.length < 8) {
      return "Password must contain at least 8 characters.";
    }

    if (!RegExp(
      r'[A-Z]',
    ).hasMatch(password)) {
      return "Password must contain at least one uppercase letter.";
    }

    if (!RegExp(
      r'[a-z]',
    ).hasMatch(password)) {
      return "Password must contain at least one lowercase letter.";
    }

    if (!RegExp(
      r'[0-9]',
    ).hasMatch(password)) {
      return "Password must contain at least one number.";
    }

    if (!RegExp(
      r'[^A-Za-z0-9]',
    ).hasMatch(password)) {
      return "Password must contain at least one special character.";
    }

    if (confirmPassword.isEmpty) {
      return "Please confirm the password.";
    }

    if (password != confirmPassword) {
      return "Passwords do not match.";
    }

    return null;
  }

  // ============================================================
  // CREATE ADMINISTRATOR ACCOUNT
  // ============================================================

  Future<void> _createAdminAccount() async {
    if (isSaving) {
      return;
    }

    final validationMessage =
        _validateForm();

    if (validationMessage != null) {
      _showMessage(
        validationMessage,
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      // --------------------------------------------------------
      // CURRENT SCHOOL
      // --------------------------------------------------------

      final school =
          await DatabaseHelper.instance
              .getCurrentSchool();

      if (school == null) {
        throw Exception(
          "No school has been configured. Please complete School Setup first.",
        );
      }

      final schoolId =
          int.tryParse(
        '${school['id']}',
      );

      if (schoolId == null) {
        throw Exception(
          "The configured school does not have a valid School ID.",
        );
      }

      // --------------------------------------------------------
      // NORMALIZE DATA
      // --------------------------------------------------------

      final fullName =
          fullNameController.text.trim();

      final username =
          usernameController.text
              .trim()
              .toLowerCase();

      final password =
          passwordController.text;

      final phone =
          phoneController.text.trim();

      final email =
          emailController.text.trim();

      const displayTitle =
          "School Administrator";

      const systemRole =
          "ADMINISTRATOR";

      // --------------------------------------------------------
      // USERNAME CHECK
      // --------------------------------------------------------

      final usernameExists =
          await DatabaseHelper.instance
              .userAccountUsernameExists(
        schoolId,
        username,
      );

      if (usernameExists) {
        throw Exception(
          'Username "$username" already exists for this school.',
        );
      }

      // --------------------------------------------------------
      // SECURE PASSWORD HASHING
      // --------------------------------------------------------

      final passwordResult =
          await PasswordHasher.hashPassword(
        password,
      );

      // --------------------------------------------------------
      // CREATE DATABASE ACCOUNT
      // --------------------------------------------------------

      await DatabaseHelper.instance
          .createUserAccount(
        {
          'schoolId': schoolId,
          'displayName': fullName,
          'displayTitle': displayTitle,
          'systemRole': systemRole,
          'username': username,
          'passwordHash':
              passwordResult.hash,
          'passwordSalt':
              passwordResult.salt,
          'passwordAlgorithm':
              'Argon2id',
          'passwordMemory':
              PasswordHasher.memory,
          'passwordIterations':
              PasswordHasher.iterations,
          'passwordParallelism':
              PasswordHasher.parallelism,
          'email': email,
          'phone': phone,
          'accountStatus': 'Active',
        },
      );

      if (!mounted) {
        return;
      }

      // --------------------------------------------------------
      // CLEAR PASSWORD VALUES FROM MEMORY VARIABLES
      // --------------------------------------------------------

      passwordController.clear();
      confirmPasswordController.clear();

      // --------------------------------------------------------
      // SUCCESS MESSAGE
      // --------------------------------------------------------

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Administrator account created successfully.",
          ),
        ),
      );

      // --------------------------------------------------------
      // DASHBOARD
      // --------------------------------------------------------
      //
      // Login/authentication is not connected yet, so we do not
      // mark the entire installation as fully authenticated here.
      // The next authentication phase will connect the saved
      // accounts to the proper login and role-based dashboard.
      //

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProprietorDashboardScreen(
            proprietorName:
                "Institution Head",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        e.toString().replaceFirst(
              "Exception: ",
              "",
            ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // FIELD
  // ============================================================

  Widget _textField({
    required TextEditingController
        controller,
    required String label,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      enabled: !isSaving,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border:
            const OutlineInputBorder(),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Administrator Setup",
        ),
        backgroundColor:
            Colors.amber,
        foregroundColor:
            Colors.black,
      ),
      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Create School Administrator",
              style: TextStyle(
                fontSize: 26,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Create the account that will "
              "manage administrative operations "
              "within your ChampionOne school system.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            // --------------------------------------------------
            // ACCOUNT ROLE
            // --------------------------------------------------

            Container(
              width:
                  double.infinity,
              padding:
                  const EdgeInsets.all(15),
              decoration:
                  BoxDecoration(
                border: Border.all(
                  color: Colors.amber,
                ),
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons
                            .admin_panel_settings,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Account Role: School Administrator",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "System Role: ADMINISTRATOR",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --------------------------------------------------
            // PERSONAL INFORMATION
            // --------------------------------------------------

            const Text(
              "Administrator Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _textField(
              controller:
                  fullNameController,
              label: "Full Name",
            ),

            const SizedBox(height: 15),

            _textField(
              controller:
                  phoneController,
              label: "Phone Number",
              keyboardType:
                  TextInputType.phone,
            ),

            const SizedBox(height: 15),

            _textField(
              controller:
                  emailController,
              label: "Email Address",
              keyboardType:
                  TextInputType.emailAddress,
            ),

            const SizedBox(height: 25),

            // --------------------------------------------------
            // LOGIN INFORMATION
            // --------------------------------------------------

            const Text(
              "Login Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _textField(
              controller:
                  usernameController,
              label: "Username",
            ),

            const SizedBox(height: 15),

            _textField(
              controller:
                  passwordController,
              label: "Password",
              obscureText: true,
            ),

            const SizedBox(height: 10),

            const Text(
              "Password must contain at least "
              "8 characters, including uppercase, "
              "lowercase, number, and special character.",
              style: TextStyle(
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 15),

            _textField(
              controller:
                  confirmPasswordController,
              label: "Confirm Password",
              obscureText: true,
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------
            // CREATE BUTTON
            // --------------------------------------------------

            SizedBox(
              width:
                  double.infinity,
              height: 55,
              child:
                  ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.amber,
                  foregroundColor:
                      Colors.black,
                ),
                onPressed:
                    isSaving
                        ? null
                        : _createAdminAccount,
                child:
                    isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 3,
                              color:
                                  Colors.black,
                            ),
                          )
                        : const Text(
                            "CREATE ADMIN ACCOUNT",
                            style:
                                TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}