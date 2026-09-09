import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import '../../security/password_hasher.dart';
import 'admin_setup_screen.dart';

class InstitutionHeadSetupScreen
    extends StatefulWidget {
  final String roleTitle;
  final String systemRole;

  const InstitutionHeadSetupScreen({
    super.key,
    required this.roleTitle,
    required this.systemRole,
  });

  @override
  State<InstitutionHeadSetupScreen>
      createState() =>
          _InstitutionHeadSetupScreenState();
}

class _InstitutionHeadSetupScreenState
    extends State<
        InstitutionHeadSetupScreen> {
  final TextEditingController
      nameController =
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

  @override
  void dispose() {
    nameController.dispose();
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
    final name =
        nameController.text.trim();

    final username =
        usernameController.text.trim();

    final password =
        passwordController.text;

    final confirmPassword =
        confirmPasswordController.text;

    if (name.isEmpty) {
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
  // CREATE ACCOUNT
  // ============================================================

  Future<void> _createAccount() async {
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
          school['id'];

      if (schoolId == null) {
        throw Exception(
          "The configured school does not have a valid School ID.",
        );
      }

      // --------------------------------------------------------
      // NORMALIZED ACCOUNT DATA
      // --------------------------------------------------------

      final displayName =
          nameController.text.trim();

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

      // --------------------------------------------------------
      // USERNAME CHECK
      // --------------------------------------------------------

      final usernameExists =
          await DatabaseHelper.instance
              .userAccountUsernameExists(
        schoolId as int,
        username,
      );

      if (usernameExists) {
        throw Exception(
          'Username "$username" already exists for this school.',
        );
      }

      // --------------------------------------------------------
      // ARGON2ID PASSWORD HASH
      // --------------------------------------------------------

      final passwordResult =
          await PasswordHasher.hashPassword(
        password,
      );

      // --------------------------------------------------------
      // DATABASE
      // --------------------------------------------------------

      await DatabaseHelper.instance
          .createUserAccount(
        {
          'schoolId': schoolId,
          'displayName': displayName,
          'displayTitle':
              widget.roleTitle,
          'systemRole':
              widget.systemRole,
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
      // SUCCESS
      // --------------------------------------------------------

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Institution Head account created successfully.",
          ),
        ),
      );

      // --------------------------------------------------------
      // NEXT SETUP STAGE
      // --------------------------------------------------------

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const AdminSetupScreen(),
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
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
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: !isSaving,
      decoration:
          InputDecoration(
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
        title: Text(
          "Create ${widget.roleTitle} Account",
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
              "Institution Head Information",
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Create the account for the "
              "${widget.roleTitle}.",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 15),

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
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    "Display Title: "
                    "${widget.roleTitle}",
                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "System Role: "
                    "${widget.systemRole}",
                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _textField(
              controller:
                  nameController,
              label: "Full Name",
            ),

            const SizedBox(height: 20),

            _textField(
              controller:
                  usernameController,
              label: "Username",
            ),

            const SizedBox(height: 20),

            _textField(
              controller:
                  passwordController,
              label: "Password",
              obscureText: true,
            ),

            const SizedBox(height: 12),

            const Text(
              "Password must contain at least "
              "8 characters, including uppercase, "
              "lowercase, number, and special character.",
              style: TextStyle(
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            _textField(
              controller:
                  confirmPasswordController,
              label: "Confirm Password",
              obscureText: true,
            ),

            const SizedBox(height: 20),

            _textField(
              controller:
                  phoneController,
              label: "Phone Number",
              keyboardType:
                  TextInputType.phone,
            ),

            const SizedBox(height: 20),

            _textField(
              controller:
                  emailController,
              label: "Email Address",
              keyboardType:
                  TextInputType.emailAddress,
            ),

            const SizedBox(height: 30),

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
                        : _createAccount,
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
                            "CREATE ACCOUNT & CONTINUE",
                            style:
                                TextStyle(
                              fontSize: 16,
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