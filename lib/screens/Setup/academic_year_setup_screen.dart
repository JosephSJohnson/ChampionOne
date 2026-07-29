import 'package:flutter/material.dart';
import 'role_setup_screen.dart';

class AcademicYearSetupScreen extends StatefulWidget {
  const AcademicYearSetupScreen({super.key});

  @override
  State<AcademicYearSetupScreen> createState() =>
      _AcademicYearSetupScreenState();
}

class _AcademicYearSetupScreenState
    extends State<AcademicYearSetupScreen> {

  final academicYearController = TextEditingController();
  final openingDateController = TextEditingController();
  final closingDateController = TextEditingController();
  final termsController = TextEditingController();

  @override
  void dispose() {
    academicYearController.dispose();
    openingDateController.dispose();
    closingDateController.dispose();
    termsController.dispose();
    super.dispose();
  }

  Widget buildField(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Academic Year Setup"),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const Text(
              "Create Academic Year",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            buildField(
              "Academic Year (Example: 2026/2027)",
              academicYearController,
            ),

            buildField(
              "Opening Date",
              openingDateController,
            ),

            buildField(
              "Closing Date",
              closingDateController,
            ),

            buildField(
              "Number of Terms",
              termsController,
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const RoleSetupScreen()
                    ),
                  );
                },
                child: const Text(
                  "CREATE ACADEMIC YEAR",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
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