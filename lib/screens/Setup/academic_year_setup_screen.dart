import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import 'role_setup_screen.dart';

class AcademicYearSetupScreen extends StatefulWidget {
  const AcademicYearSetupScreen({
    super.key,
  });

  @override
  State<AcademicYearSetupScreen> createState() =>
      _AcademicYearSetupScreenState();
}

class _AcademicYearSetupScreenState
    extends State<AcademicYearSetupScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController academicYearController =
      TextEditingController();

  final TextEditingController openingDateController =
      TextEditingController();

  final TextEditingController closingDateController =
      TextEditingController();

  final TextEditingController termsController =
      TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  bool isSaving = false;
  bool isLoadingHistory = true;

  List<Map<String, dynamic>> academicYears = [];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadAcademicYears();
  }

  // ============================================================
  // LOAD ACADEMIC YEARS
  // ============================================================

  Future<void> _loadAcademicYears() async {
    try {
      final result =
          await DatabaseHelper.instance.getAcademicYears();

      if (!mounted) {
        return;
      }

      setState(() {
        academicYears = result;
        isLoadingHistory = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoadingHistory = false;
      });

      _showMessage(
        "Unable to load academic year history: $e",
      );
    }
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool _validateForm() {
    final year =
        academicYearController.text.trim();

    final openingDate =
        openingDateController.text.trim();

    final closingDate =
        closingDateController.text.trim();

    final terms =
        termsController.text.trim();

    if (year.isEmpty) {
      _showMessage(
        "Please enter the academic year.",
      );

      return false;
    }

    // Example: 2026/2027
    final yearMatch =
        RegExp(r'^(\d{4})/(\d{4})$')
            .firstMatch(year);

    if (yearMatch == null) {
      _showMessage(
        "Academic year must be in this format: 2026/2027",
      );

      return false;
    }

    final firstYear =
        int.tryParse(yearMatch.group(1)!);

    final secondYear =
        int.tryParse(yearMatch.group(2)!);

    if (firstYear == null ||
        secondYear == null ||
        secondYear != firstYear + 1) {
      _showMessage(
        "Please enter a valid academic year, for example 2026/2027.",
      );

      return false;
    }

    if (openingDate.isEmpty) {
      _showMessage(
        "Please enter the opening date.",
      );

      return false;
    }

    if (closingDate.isEmpty) {
      _showMessage(
        "Please enter the closing date.",
      );

      return false;
    }

    if (terms.isEmpty) {
      _showMessage(
        "Please enter the number of terms.",
      );

      return false;
    }

    return true;
  }

  // ============================================================
  // CREATE ACADEMIC YEAR
  // ============================================================

  Future<void> _createAcademicYear() async {
    if (isSaving) {
      return;
    }

    if (!_validateForm()) {
      return;
    }

    final year =
        academicYearController.text.trim();

    final openingDate =
        openingDateController.text.trim();

    final closingDate =
        closingDateController.text.trim();

    final numberOfTerms =
        termsController.text.trim();

    setState(() {
      isSaving = true;
    });

    try {
      await DatabaseHelper.instance
          .createAcademicYear(
        {
          'academicYear': year,
          'openingDate': openingDate,
          'closingDate': closingDate,
          'numberOfTerms': numberOfTerms,
        },
      );

      if (!mounted) {
        return;
      }

      // --------------------------------------------------------
      // CLEAR FORM IMMEDIATELY
      // --------------------------------------------------------

      academicYearController.clear();
      openingDateController.clear();
      closingDateController.clear();
      termsController.clear();

      // --------------------------------------------------------
      // RELOAD HISTORY
      // --------------------------------------------------------

      await _loadAcademicYears();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "$year created successfully.",
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
  // CONTINUE TO ROLE SETUP
  // ============================================================

  void _continueToRoleSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const RoleSetupScreen(),
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
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

  Widget buildField(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border:
              const OutlineInputBorder(),
        ),
      ),
    );
  }

  // ============================================================
  // ACADEMIC YEAR CARD
  // ============================================================

  Widget _academicYearCard(
    Map<String, dynamic> year,
  ) {
    final academicYear =
        (year['academicYear'] ?? '')
            .toString();

    final openingDate =
        (year['openingDate'] ?? '')
            .toString();

    final closingDate =
        (year['closingDate'] ?? '')
            .toString();

    final terms =
        (year['numberOfTerms'] ?? '')
            .toString();

    final status =
        (year['status'] ?? '')
            .toString();

    final isCurrent =
        (year['isCurrent'] ?? 0) == 1;

    return Card(
      margin:
          const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    academicYear,
                    style:
                        const TextStyle(
                      fontSize: 19,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration:
                      BoxDecoration(
                    color: isCurrent
                        ? Colors.green
                        : Colors.grey,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Text(
                    isCurrent
                        ? "CURRENT"
                        : "PREVIOUS",
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              "Opening Date: $openingDate",
            ),

            const SizedBox(height: 4),

            Text(
              "Closing Date: $closingDate",
            ),

            const SizedBox(height: 4),

            Text(
              "Number of Terms: $terms",
            ),

            const SizedBox(height: 4),

            Text(
              "Status: $status",
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    academicYearController.dispose();
    openingDateController.dispose();
    closingDateController.dispose();
    termsController.dispose();

    super.dispose();
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
        title:
            const Text("Academic Year Setup"),
        backgroundColor:
            Colors.amber,
        foregroundColor:
            Colors.black,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [
            const Text(
              "Create Academic Year",
              style: TextStyle(
                fontSize: 26,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            buildField(
              "Academic Year",
              academicYearController,
              hint: "2026/2027",
            ),

            buildField(
              "Opening Date",
              openingDateController,
              hint: "09/05/2026",
            ),

            buildField(
              "Closing Date",
              closingDateController,
              hint: "05/30/2027",
            ),

            buildField(
              "Number of Terms",
              termsController,
              hint: "3",
              keyboardType:
                  TextInputType.number,
            ),

            const SizedBox(
              height: 10,
            ),

            SizedBox(
              height: 55,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.amber,
                  foregroundColor:
                      Colors.black,
                ),
                onPressed: isSaving
                    ? null
                    : _createAcademicYear,
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
                        "CREATE ACADEMIC YEAR",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed:
                    _continueToRoleSetup,
                child: const Text(
                  "CONTINUE TO ROLE SETUP",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 35,
            ),

            const Text(
              "Academic Year History",
              style: TextStyle(
                fontSize: 23,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            if (isLoadingHistory)
              const Center(
                child:
                    CircularProgressIndicator(),
              )
            else if (academicYears.isEmpty)
              const Card(
                child: Padding(
                  padding:
                      EdgeInsets.all(16),
                  child: Text(
                    "No academic years have been created yet.",
                  ),
                ),
              )
            else
              ...academicYears.map(
                _academicYearCard,
              ),
          ],
        ),
      ),
    );
  }
}