import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import 'academic_year_setup_screen.dart';

class SchoolSetupScreen extends StatefulWidget {
  const SchoolSetupScreen({super.key});

  @override
  State<SchoolSetupScreen> createState() =>
      _SchoolSetupScreenState();
}

class _SchoolSetupScreenState
    extends State<SchoolSetupScreen> {
  final schoolNameController =
      TextEditingController();

  final schoolTypeController =
      TextEditingController();

  final schoolLocationController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final emailController =
      TextEditingController();

  bool isSaving = false;

  @override
  void dispose() {
    schoolNameController.dispose();
    schoolTypeController.dispose();
    schoolLocationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool _validateForm() {
    if (schoolNameController.text
        .trim()
        .isEmpty) {
      _showMessage(
        "School name is required.",
      );

      return false;
    }

    if (schoolTypeController.text
        .trim()
        .isEmpty) {
      _showMessage(
        "School type is required.",
      );

      return false;
    }

    if (schoolLocationController.text
        .trim()
        .isEmpty) {
      _showMessage(
        "School location is required.",
      );

      return false;
    }

    if (phoneController.text
        .trim()
        .isEmpty) {
      _showMessage(
        "Contact number is required.",
      );

      return false;
    }

    final email =
        emailController.text.trim();

    if (email.isNotEmpty &&
        !_isValidEmail(email)) {
      _showMessage(
        "Please enter a valid email address.",
      );

      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);
  }

  // ============================================================
  // SAVE SCHOOL
  // ============================================================

  Future<void> _saveSchool() async {
    if (isSaving) {
      return;
    }

    if (!_validateForm()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      // --------------------------------------------------------
      // Check whether a school has already been configured.
      // --------------------------------------------------------

      final existingSchool =
          await DatabaseHelper.instance
              .getCurrentSchool();

      if (existingSchool != null) {
        if (!mounted) {
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const AcademicYearSetupScreen(),
          ),
        );

        return;
      }

      // --------------------------------------------------------
      // Create permanent school record.
      // --------------------------------------------------------

      final schoolId =
          await DatabaseHelper.instance
              .createSchool(
        {
          'schoolName':
              schoolNameController.text
                  .trim(),

          'schoolType':
              schoolTypeController.text
                  .trim(),

          'location':
              schoolLocationController.text
                  .trim(),

          'phone':
              phoneController.text
                  .trim(),

          'email':
              emailController.text
                  .trim(),
        },
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "School information saved successfully. "
            "School ID: $schoolId",
          ),
        ),
      );

      // --------------------------------------------------------
      // Continue to Academic Year Setup.
      // --------------------------------------------------------

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const AcademicYearSetupScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        "Failed to save school information: $e",
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

  void _showMessage(String message) {
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

  Widget buildField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration:
            InputDecoration(
          labelText: label,
          border:
              const OutlineInputBorder(),
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("School Setup"),
        backgroundColor:
            Colors.amber,
      ),
      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            const Text(
              "School Information",
              style: TextStyle(
                fontSize: 26,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              "Enter the official information "
              "for this school.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            buildField(
              "School Name",
              schoolNameController,
            ),

            buildField(
              "School Type",
              schoolTypeController,
            ),

            buildField(
              "School Location",
              schoolLocationController,
            ),

            buildField(
              "Contact Number",
              phoneController,
              keyboardType:
                  TextInputType.phone,
            ),

            buildField(
              "Email Address",
              emailController,
              keyboardType:
                  TextInputType.emailAddress,
            ),

            const SizedBox(
              height: 10,
            ),

            SizedBox(
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
                        : _saveSchool,
                child: isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        "SAVE & CONTINUE",
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