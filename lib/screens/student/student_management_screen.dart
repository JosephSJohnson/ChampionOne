import 'package:flutter/material.dart';

import 'student_registration_screen.dart';
import 'student_directory_screen.dart';

class StudentManagementScreen extends StatelessWidget {
  const StudentManagementScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Student Management",
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Manage Students",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              "Register, manage, and view student admission records.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // ====================================================
            // REGISTER STUDENT
            // ====================================================

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.amber,
                  foregroundColor:
                      Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const StudentRegistrationScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.person_add,
                ),
                label: const Text(
                  "REGISTER STUDENT",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // ====================================================
            // STUDENT DIRECTORY
            // ====================================================

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue,
                  foregroundColor:
                      Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const StudentDirectoryScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.people,
                ),
                label: const Text(
                  "VIEW STUDENT DIRECTORY",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            const Text(
              "Admission Categories",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            _admissionCard(
              Icons.person_add_alt_1,
              "New Student",
            ),

            _admissionCard(
              Icons.sync_alt,
              "Transfer Student",
            ),

            _admissionCard(
              Icons.replay,
              "Returning Student",
            ),

            _admissionCard(
              Icons.upgrade,
              "Promotion / Internal Progression",
            ),

            _admissionCard(
              Icons.school,
              "Graduate / Advanced Entry",
            ),
          ],
        ),
      ),
    );
  }

  Widget _admissionCard(
    IconData icon,
    String title,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 32,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }
}