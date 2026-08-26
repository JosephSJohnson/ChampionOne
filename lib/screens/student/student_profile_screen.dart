import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../data/student_data.dart';
import '../../database/database_helper.dart';
import '../../models/student_model.dart';
import '../../utils/file_storage.dart';

import 'edit_student_screen.dart';
import 'student_documents_screen.dart';

class StudentProfileScreen extends StatefulWidget {
  final StudentModel student;

  const StudentProfileScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState
    extends State<StudentProfileScreen> {
  late StudentModel student;

  @override
  void initState() {
    super.initState();

    student = widget.student;
  }

  // ============================================================
  // LOAD STUDENT PHOTO
  // ============================================================

  Future<Uint8List?> _loadStudentPhoto(
    String imagePath,
  ) async {
    if (imagePath.isEmpty) {
      return null;
    }

    return FileStorage.readFile(imagePath);
  }

  // ============================================================
  // FILE NAME
  // ============================================================

  String _fileName(String filePath) {
    if (filePath.isEmpty) {
      return "";
    }

    final normalized =
        filePath.replaceAll('\\', '/');

    return normalized.split('/').last;
  }

  // ============================================================
  // DELETE STUDENT
  // ============================================================

  Future<void> deleteStudent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Delete Student",
          ),
          content: Text(
            "Are you sure you want to delete\n\n"
            "${student.fullName}\n"
            "${student.studentID}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "Delete",
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      // Delete database record.
      await DatabaseHelper.instance
          .deleteStudent(
        student.studentID,
      );

      // Delete from in-memory list.
      StudentData.deleteStudent(
        student.studentID,
      );

      // Delete stored student photo.
      if (student.studentPhoto.isNotEmpty) {
        await FileStorage.deleteFile(
          student.studentPhoto,
        );
      }

      // Delete stored documents.
      if (student.transcriptDocument.isNotEmpty) {
        await FileStorage.deleteFile(
          student.transcriptDocument,
        );
      }

      if (student.recommendationDocument.isNotEmpty) {
        await FileStorage.deleteFile(
          student.recommendationDocument,
        );
      }

      if (student.transferCertificate.isNotEmpty) {
        await FileStorage.deleteFile(
          student.transferCertificate,
        );
      }

      if (student.otherDocuments.isNotEmpty) {
        await FileStorage.deleteFile(
          student.otherDocuments,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to delete student: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // EDIT PLACEHOLDER
  // ============================================================
  //
  // We will connect this to EditStudentScreen next.
  // For now it remains disabled so the profile itself
  // stays fully functional.

  void showEditComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Student editing will be connected next.",
        ),
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _buildInfo(
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value.isEmpty ? "-" : value,
        ),
      ),
    );
  }

  // ============================================================
  // DOCUMENT CARD
  // ============================================================

  Widget _buildDocumentCard({
    required String title,
    required String filePath,
  }) {
    final hasDocument =
        filePath.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        leading: Icon(
          hasDocument
              ? Icons.description
              : Icons.description_outlined,
          color: hasDocument
              ? Colors.blue
              : Colors.grey,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          hasDocument
              ? _fileName(filePath)
              : "No document uploaded",
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
        title: const Text(
          "Student Profile",
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [
          // ======================================================
          // EDIT
          // ======================================================

          IconButton(
  icon: const Icon(
    Icons.edit,
  ),
  tooltip: "Edit Student",
  onPressed: () async {
    final updatedStudent =
        await Navigator.push<StudentModel>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditStudentScreen(
          student: student,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    if (updatedStudent == null) {
      return;
    }

    StudentData.updateStudent(
      updatedStudent,
    );

    setState(() {
      student = updatedStudent;
    });
  },
),

const SizedBox(
  height: 15,
),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () async {
      final updatedStudent =
          await Navigator.push<StudentModel>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              StudentDocumentsScreen(
            student: student,
          ),
        ),
      );

      if (!mounted) {
        return;
      }

      if (updatedStudent != null) {
        StudentData.updateStudent(
          updatedStudent,
        );

        setState(() {
          student = updatedStudent;
        });
      }
    },
    icon: const Icon(
      Icons.folder,
    ),
    label: const Text(
      "STUDENT DOCUMENTS",
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.amber,
      foregroundColor: Colors.black,
    ),
  ),
),

          // ======================================================
          // DELETE
          // ======================================================

          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            tooltip: "Delete Student",
            onPressed: deleteStudent,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ====================================================
            // STUDENT PHOTO
            // ====================================================

            FutureBuilder<Uint8List?>(
              future: _loadStudentPhoto(
                student.studentPhoto,
              ),
              builder: (
                context,
                snapshot,
              ) {
                final imageBytes =
                    snapshot.data;

                return CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      imageBytes != null
                          ? MemoryImage(
                              imageBytes,
                            )
                          : null,
                  child:
                      imageBytes == null
                          ? Text(
                              student.fullName
                                      .isNotEmpty
                                  ? student
                                      .fullName[0]
                                      .toUpperCase()
                                  : "?",
                              style:
                                  const TextStyle(
                                fontSize: 40,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            )
                          : null,
                );
              },
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              student.fullName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            Text(
              "Student ID: ${student.studentID}",
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // ====================================================
            // ADMISSION INFORMATION
            // ====================================================

            const Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "Admission Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            _buildInfo(
              "School Type",
              student.schoolType,
            ),

            _buildInfo(
              "Admission Category",
              student.admissionCategory,
            ),

            _buildInfo(
              "Academic Year",
              student.academicYear,
            ),

            _buildInfo(
              "Admission Date",
              student.admissionDate,
            ),

            _buildInfo(
              "Student Status",
              student.studentStatus,
            ),

            // ====================================================
            // PERSONAL INFORMATION
            // ====================================================

            const SizedBox(
              height: 15,
            ),

            const Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "Personal Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            _buildInfo(
              "Full Name",
              student.fullName,
            ),

            _buildInfo(
              "Preferred Name",
              student.preferredName,
            ),

            _buildInfo(
              "Date of Birth",
              student.dateOfBirth,
            ),

            _buildInfo(
              "Gender",
              student.gender,
            ),

            _buildInfo(
              "Nationality",
              student.nationality,
            ),

            _buildInfo(
              "Address",
              student.address,
            ),

            _buildInfo(
              "Phone",
              student.phone,
            ),

            // ====================================================
            // ACADEMIC INFORMATION
            // ====================================================

            const SizedBox(
              height: 15,
            ),

            const Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "Academic Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            _buildInfo(
              "Class / Grade",
              student.classGrade,
            ),

            _buildInfo(
              "Previous School",
              student.previousSchool,
            ),

            _buildInfo(
              "Previous Grade",
              student.previousGrade,
            ),

            _buildInfo(
              "Previous Academic Year",
              student.previousAcademicYear,
            ),

            _buildInfo(
              "Faculty / School",
              student.faculty,
            ),

            _buildInfo(
              "Department",
              student.department,
            ),

            _buildInfo(
              "Program",
              student.program,
            ),

            _buildInfo(
              "Major",
              student.major,
            ),

            _buildInfo(
              "Training Level",
              student.trainingLevel,
            ),

            _buildInfo(
              "Practical Experience",
              student.practicalExperience,
            ),

            // ====================================================
            // PARENT / GUARDIAN
            // ====================================================

            const SizedBox(
              height: 15,
            ),

            const Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "Parent / Guardian",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            _buildInfo(
              "Name",
              student.parentGuardianName,
            ),

            _buildInfo(
              "Relationship",
              student.parentGuardianRelationship,
            ),

            _buildInfo(
              "Phone",
              student.parentGuardianPhone,
            ),

            _buildInfo(
              "Email",
              student.parentGuardianEmail,
            ),

            _buildInfo(
              "Address",
              student.parentGuardianAddress,
            ),

            _buildInfo(
              "Occupation",
              student.parentGuardianOccupation,
            ),

            // ====================================================
            // EMERGENCY CONTACT
            // ====================================================

            const SizedBox(
              height: 15,
            ),

            const Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "Emergency Contact",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            _buildInfo(
              "Contact Name",
              student.emergencyContactName,
            ),

            _buildInfo(
              "Contact Phone",
              student.emergencyContactPhone,
            ),

            // ====================================================
            // ADMISSION DOCUMENTS
            // ====================================================

            const SizedBox(
              height: 15,
            ),

            const Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "Admission Documents",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            _buildDocumentCard(
              title:
                  "Transcript / Academic Record",
              filePath:
                  student.transcriptDocument,
            ),

            _buildDocumentCard(
              title:
                  "Letter of Recommendation",
              filePath:
                  student.recommendationDocument,
            ),

            _buildDocumentCard(
              title:
                  "Transfer Certificate",
              filePath:
                  student.transferCertificate,
            ),

            _buildDocumentCard(
              title:
                  "Other Document",
              filePath:
                  student.otherDocuments,
            ),

            const SizedBox(
              height: 20,
            ),

            // ====================================================
            // EDIT
            // ====================================================

            SizedBox(
              width: double.infinity,
              child:
                  ElevatedButton.icon(
                onPressed:
                    showEditComingSoon,
                icon: const Icon(
                  Icons.edit,
                ),
                label: const Text(
                  "EDIT STUDENT",
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
              height: 15,
            ),

            // ====================================================
            // DELETE
            // ====================================================

            SizedBox(
              width: double.infinity,
              child:
                  ElevatedButton.icon(
                onPressed:
                    deleteStudent,
                icon: const Icon(
                  Icons.delete,
                ),
                label: const Text(
                  "DELETE STUDENT",
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,
                  foregroundColor:
                      Colors.white,
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