import 'package:flutter/material.dart';

import '../../data/student_data.dart';
import '../../database/database_helper.dart';
import '../../models/student_model.dart';

class EditStudentScreen extends StatefulWidget {
  final StudentModel student;

  const EditStudentScreen({
    super.key,
    required this.student,
  });

  @override
  State<EditStudentScreen> createState() =>
      _EditStudentScreenState();
}

class _EditStudentScreenState
    extends State<EditStudentScreen> {
  late TextEditingController fullNameController;
  late TextEditingController preferredNameController;
  late TextEditingController nationalityController;
  late TextEditingController addressController;
  late TextEditingController phoneController;

  late TextEditingController classGradeController;
  late TextEditingController previousSchoolController;
  late TextEditingController previousGradeController;
  late TextEditingController previousAcademicYearController;

  late TextEditingController facultyController;
  late TextEditingController departmentController;
  late TextEditingController programController;
  late TextEditingController majorController;
  late TextEditingController trainingLevelController;
  late TextEditingController practicalExperienceController;

  late TextEditingController parentGuardianNameController;
  late TextEditingController parentGuardianRelationshipController;
  late TextEditingController parentGuardianPhoneController;
  late TextEditingController parentGuardianEmailController;
  late TextEditingController parentGuardianAddressController;
  late TextEditingController parentGuardianOccupationController;

  late TextEditingController emergencyContactNameController;
  late TextEditingController emergencyContactPhoneController;

  String selectedGender = "";
  String selectedStudentStatus = "";

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    fullNameController = TextEditingController(
      text: widget.student.fullName,
    );

    preferredNameController = TextEditingController(
      text: widget.student.preferredName,
    );

    nationalityController = TextEditingController(
      text: widget.student.nationality,
    );

    addressController = TextEditingController(
      text: widget.student.address,
    );

    phoneController = TextEditingController(
      text: widget.student.phone,
    );

    classGradeController = TextEditingController(
      text: widget.student.classGrade,
    );

    previousSchoolController =
        TextEditingController(
      text: widget.student.previousSchool,
    );

    previousGradeController =
        TextEditingController(
      text: widget.student.previousGrade,
    );

    previousAcademicYearController =
        TextEditingController(
      text: widget.student.previousAcademicYear,
    );

    facultyController = TextEditingController(
      text: widget.student.faculty,
    );

    departmentController = TextEditingController(
      text: widget.student.department,
    );

    programController = TextEditingController(
      text: widget.student.program,
    );

    majorController = TextEditingController(
      text: widget.student.major,
    );

    trainingLevelController =
        TextEditingController(
      text: widget.student.trainingLevel,
    );

    practicalExperienceController =
        TextEditingController(
      text: widget.student.practicalExperience,
    );

    parentGuardianNameController =
        TextEditingController(
      text: widget.student.parentGuardianName,
    );

    parentGuardianRelationshipController =
        TextEditingController(
      text: widget.student
          .parentGuardianRelationship,
    );

    parentGuardianPhoneController =
        TextEditingController(
      text: widget.student.parentGuardianPhone,
    );

    parentGuardianEmailController =
        TextEditingController(
      text: widget.student.parentGuardianEmail,
    );

    parentGuardianAddressController =
        TextEditingController(
      text: widget.student.parentGuardianAddress,
    );

    parentGuardianOccupationController =
        TextEditingController(
      text:
          widget.student.parentGuardianOccupation,
    );

    emergencyContactNameController =
        TextEditingController(
      text:
          widget.student.emergencyContactName,
    );

    emergencyContactPhoneController =
        TextEditingController(
      text:
          widget.student.emergencyContactPhone,
    );

    selectedGender = widget.student.gender;
    selectedStudentStatus =
        widget.student.studentStatus;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    fullNameController.dispose();
    preferredNameController.dispose();
    nationalityController.dispose();
    addressController.dispose();
    phoneController.dispose();

    classGradeController.dispose();
    previousSchoolController.dispose();
    previousGradeController.dispose();
    previousAcademicYearController.dispose();

    facultyController.dispose();
    departmentController.dispose();
    programController.dispose();
    majorController.dispose();
    trainingLevelController.dispose();
    practicalExperienceController.dispose();

    parentGuardianNameController.dispose();
    parentGuardianRelationshipController.dispose();
    parentGuardianPhoneController.dispose();
    parentGuardianEmailController.dispose();
    parentGuardianAddressController.dispose();
    parentGuardianOccupationController.dispose();

    emergencyContactNameController.dispose();
    emergencyContactPhoneController.dispose();

    super.dispose();
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> saveChanges() async {
    final updatedStudent = StudentModel(
      id: widget.student.id,

      studentID: widget.student.studentID,

      fullName:
          fullNameController.text.trim(),

      preferredName:
          preferredNameController.text.trim(),

      dateOfBirth:
          widget.student.dateOfBirth,

      gender:
          selectedGender,

      nationality:
          nationalityController.text.trim(),

      address:
          addressController.text.trim(),

      phone:
          phoneController.text.trim(),

      schoolType:
          widget.student.schoolType,

      admissionCategory:
          widget.student.admissionCategory,

      academicYear:
          widget.student.academicYear,

      admissionDate:
          widget.student.admissionDate,

      studentStatus:
          selectedStudentStatus,

      classGrade:
          classGradeController.text.trim(),

      previousSchool:
          previousSchoolController.text.trim(),

      previousGrade:
          previousGradeController.text.trim(),

      previousAcademicYear:
          previousAcademicYearController.text.trim(),

      faculty:
          facultyController.text.trim(),

      department:
          departmentController.text.trim(),

      program:
          programController.text.trim(),

      major:
          majorController.text.trim(),

      trainingLevel:
          trainingLevelController.text.trim(),

      practicalExperience:
          practicalExperienceController.text.trim(),

      parentGuardianName:
          parentGuardianNameController.text.trim(),

      parentGuardianRelationship:
          parentGuardianRelationshipController.text.trim(),

      parentGuardianPhone:
          parentGuardianPhoneController.text.trim(),

      parentGuardianEmail:
          parentGuardianEmailController.text.trim(),

      parentGuardianAddress:
          parentGuardianAddressController.text.trim(),

      parentGuardianOccupation:
          parentGuardianOccupationController.text.trim(),

      emergencyContactName:
          emergencyContactNameController.text.trim(),

      emergencyContactPhone:
          emergencyContactPhoneController.text.trim(),

      // Keep existing stored files.
      studentPhoto:
          widget.student.studentPhoto,

      transcriptDocument:
          widget.student.transcriptDocument,

      recommendationDocument:
          widget.student.recommendationDocument,

      transferCertificate:
          widget.student.transferCertificate,

      otherDocuments:
          widget.student.otherDocuments,
    );

    try {
      await DatabaseHelper.instance
          .updateStudent(
        updatedStudent.toMap(),
      );

      if (!mounted) {
        return;
      }

      StudentData.updateStudent(
        updatedStudent,
      );

      Navigator.of(context).pop(
        updatedStudent,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to update student: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // FIELD
  // ============================================================

  Widget textField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget spacing() {
    return const SizedBox(
      height: 15,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Student",
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // ==================================================
            // PERSONAL INFORMATION
            // ==================================================

            sectionTitle(
              "Personal Information",
            ),

            textField(
              controller:
                  fullNameController,
              label:
                  "Full Name",
            ),

            spacing(),

            textField(
              controller:
                  preferredNameController,
              label:
                  "Preferred Name",
            ),

            spacing(),

            textField(
              controller:
                  nationalityController,
              label:
                  "Nationality",
            ),

            spacing(),

            textField(
              controller:
                  addressController,
              label:
                  "Address",
              maxLines: 2,
            ),

            spacing(),

            textField(
              controller:
                  phoneController,
              label:
                  "Phone",
              keyboardType:
                  TextInputType.phone,
            ),

            // ==================================================
            // ACADEMIC
            // ==================================================

            const SizedBox(
              height: 25,
            ),

            sectionTitle(
              "Academic Information",
            ),

            textField(
              controller:
                  classGradeController,
              label:
                  "Class / Grade",
            ),

            spacing(),

            textField(
              controller:
                  previousSchoolController,
              label:
                  "Previous School",
            ),

            spacing(),

            textField(
              controller:
                  previousGradeController,
              label:
                  "Previous Grade",
            ),

            spacing(),

            textField(
              controller:
                  previousAcademicYearController,
              label:
                  "Previous Academic Year",
            ),

            spacing(),

            textField(
              controller:
                  facultyController,
              label:
                  "Faculty / School",
            ),

            spacing(),

            textField(
              controller:
                  departmentController,
              label:
                  "Department",
            ),

            spacing(),

            textField(
              controller:
                  programController,
              label:
                  "Program",
            ),

            spacing(),

            textField(
              controller:
                  majorController,
              label:
                  "Major",
            ),

            spacing(),

            textField(
              controller:
                  trainingLevelController,
              label:
                  "Training Level",
            ),

            spacing(),

            textField(
              controller:
                  practicalExperienceController,
              label:
                  "Practical Experience",
              maxLines: 3,
            ),

            // ==================================================
            // PARENT / GUARDIAN
            // ==================================================

            const SizedBox(
              height: 25,
            ),

            sectionTitle(
              "Parent / Guardian",
            ),

            textField(
              controller:
                  parentGuardianNameController,
              label:
                  "Parent / Guardian Name",
            ),

            spacing(),

            textField(
              controller:
                  parentGuardianRelationshipController,
              label:
                  "Relationship",
            ),

            spacing(),

            textField(
              controller:
                  parentGuardianPhoneController,
              label:
                  "Phone",
              keyboardType:
                  TextInputType.phone,
            ),

            spacing(),

            textField(
              controller:
                  parentGuardianEmailController,
              label:
                  "Email",
              keyboardType:
                  TextInputType.emailAddress,
            ),

            spacing(),

            textField(
              controller:
                  parentGuardianAddressController,
              label:
                  "Address",
              maxLines: 2,
            ),

            spacing(),

            textField(
              controller:
                  parentGuardianOccupationController,
              label:
                  "Occupation",
            ),

            // ==================================================
            // EMERGENCY
            // ==================================================

            const SizedBox(
              height: 25,
            ),

            sectionTitle(
              "Emergency Contact",
            ),

            textField(
              controller:
                  emergencyContactNameController,
              label:
                  "Emergency Contact Name",
            ),

            spacing(),

            textField(
              controller:
                  emergencyContactPhoneController,
              label:
                  "Emergency Contact Phone",
              keyboardType:
                  TextInputType.phone,
            ),

            const SizedBox(
              height: 30,
            ),

            // ==================================================
            // SAVE
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed:
                    saveChanges,
                icon: const Icon(
                  Icons.save,
                ),
                label: const Text(
                  "SAVE CHANGES",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.amber,
                  foregroundColor:
                      Colors.black,
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}