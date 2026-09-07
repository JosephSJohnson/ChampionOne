import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import 'institution_head_setup_screen.dart';

class RoleSetupScreen extends StatefulWidget {
  const RoleSetupScreen({super.key});

  @override
  State<RoleSetupScreen> createState() =>
      _RoleSetupScreenState();
}

class _RoleSetupScreenState
    extends State<RoleSetupScreen> {
  String headTitle = "Proprietor";
  String principalTitle = "Principal";
  String academicTitle = "VP Academic Affairs";
  String instructionTitle =
      "Vice Principal for Instruction";
  String studentAffairsTitle =
      "VP Student Affairs";
  String financeTitle = "Finance Officer";
  String registrarTitle = "Registrar";
  String teacherTitle = "Teacher";

  bool isSaving = false;

  final List<String> headTitles = [
    "Proprietor",
    "Proprietress",
    "Director",
    "Executive Director",
    "President",
    "CEO",
  ];

  final List<String> principalTitles = [
    "Principal",
    "Headmaster",
    "Headmistress",
    "Head Teacher",
  ];

  final List<String> academicTitles = [
    "VP Academic Affairs",
    "Dean of Academics",
    "Academic Director",
  ];

  final List<String> instructionTitles = [
    "Vice Principal for Instruction",
    "VP for Instruction",
    "Director of Instruction",
    "Instructional Coordinator",
  ];

  final List<String> studentAffairsTitles = [
    "VP Student Affairs",
    "Dean of Students",
    "Student Affairs Director",
  ];

  final List<String> financeTitles = [
    "Finance Officer",
    "Bursar",
    "Accountant",
  ];

  final List<String> registrarTitles = [
    "Registrar",
    "Admissions Officer",
    "Registrar / Admissions Officer",
  ];

  final List<String> teacherTitles = [
    "Teacher",
    "Instructor",
    "Tutor",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Leadership Titles"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Customize your school leadership titles",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "ChampionOne keeps the system role "
              "separate from the title displayed by "
              "your school.",
              style: TextStyle(
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

            _buildDropdown(
              title:
                  "Head of Institution",
              value: headTitle,
              items: headTitles,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  headTitle = value;
                });
              },
            ),

            _buildDropdown(
              title: "Principal",
              value: principalTitle,
              items: principalTitles,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  principalTitle = value;
                });
              },
            ),

            _buildDropdown(
              title:
                  "Academic Affairs",
              value: academicTitle,
              items: academicTitles,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  academicTitle = value;
                });
              },
            ),

            _buildDropdown(
              title:
                  "Instruction",
              value: instructionTitle,
              items: instructionTitles,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  instructionTitle = value;
                });
              },
            ),

            _buildDropdown(
              title:
                  "Student Affairs",
              value:
                  studentAffairsTitle,
              items:
                  studentAffairsTitles,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  studentAffairsTitle =
                      value;
                });
              },
            ),

            _buildDropdown(
              title: "Registrar",
              value: registrarTitle,
              items: registrarTitles,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  registrarTitle = value;
                });
              },
            ),

            _buildDropdown(
              title: "Finance",
              value: financeTitle,
              items: financeTitles,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  financeTitle = value;
                });
              },
            ),

            _buildDropdown(
              title: "Teacher",
              value: teacherTitle,
              items: teacherTitles,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  teacherTitle = value;
                });
              },
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(15),
              decoration: BoxDecoration(
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
                  Text(
                    "System roles",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Proprietor • Principal • VPA • VPI • "
                    "VPSA • Registrar • Finance • Teacher",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
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
                onPressed: isSaving
                    ? null
                    : _saveAndContinue,
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
                        style: TextStyle(
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

  // ============================================================
  // SAVE ROLES
  // ============================================================

  Future<void> _saveAndContinue() async {
    if (isSaving) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final school =
          await DatabaseHelper.instance
              .getCurrentSchool();

      if (school == null) {
        throw Exception(
          "School information has not been configured.",
        );
      }

      final schoolId =
          school['id'] as int;

      final roles =
          <String, String>{
        "PROPRIETOR":
            headTitle,
        "PRINCIPAL":
            principalTitle,
        "VPA":
            academicTitle,
        "VPI":
            instructionTitle,
        "VPSA":
            studentAffairsTitle,
        "REGISTRAR":
            registrarTitle,
        "FINANCE":
            financeTitle,
        "TEACHER":
            teacherTitle,
      };

      await DatabaseHelper.instance
          .saveLeadershipRoles(
        schoolId,
        roles,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Leadership roles saved successfully.",
          ),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              InstitutionHeadSetupScreen(
            roleTitle:
                headTitle,
            systemRole:
                "PROPRIETOR",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Unable to save leadership roles: $e",
          ),
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
  // DROPDOWN
  // ============================================================

  Widget _buildDropdown({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?>
        onChanged,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          initialValue: value,
          decoration:
              const InputDecoration(
            border:
                OutlineInputBorder(),
          ),
          items: items.map(
            (item) {
              return DropdownMenuItem<
                  String>(
                value: item,
                child: Text(item),
              );
            },
          ).toList(),
          onChanged:
              onChanged,
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}