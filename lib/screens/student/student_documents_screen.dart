import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:universal_html/html.dart' as html;

import '../../database/database_helper.dart';
import '../../models/student_model.dart';
import '../../utils/file_storage.dart';

class StudentDocumentsScreen extends StatefulWidget {
  final StudentModel student;

  const StudentDocumentsScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentDocumentsScreen> createState() =>
      _StudentDocumentsScreenState();
}

class _StudentDocumentsScreenState
    extends State<StudentDocumentsScreen> {
  late StudentModel student;

  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    student = widget.student;
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
  // MIME TYPE
  // ============================================================

  String _mimeType(String fileName) {
    final lower = fileName.toLowerCase();

    if (lower.endsWith('.pdf')) {
      return 'application/pdf';
    }

    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg')) {
      return 'image/jpeg';
    }

    if (lower.endsWith('.png')) {
      return 'image/png';
    }

    if (lower.endsWith('.gif')) {
      return 'image/gif';
    }

    if (lower.endsWith('.webp')) {
      return 'image/webp';
    }

    if (lower.endsWith('.txt')) {
      return 'text/plain';
    }

    if (lower.endsWith('.doc')) {
      return 'application/msword';
    }

    if (lower.endsWith('.docx')) {
      return
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    }

    if (lower.endsWith('.xls')) {
      return 'application/vnd.ms-excel';
    }

    if (lower.endsWith('.xlsx')) {
      return
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    }

    if (lower.endsWith('.ppt')) {
      return 'application/vnd.ms-powerpoint';
    }

    if (lower.endsWith('.pptx')) {
      return
          'application/vnd.openxmlformats-officedocument.presentationml.presentation';
    }

    return 'application/octet-stream';
  }

  // ============================================================
  // PICK DOCUMENT
  // ============================================================

  Future<void> _replaceDocument(
    String documentType,
    String currentPath,
  ) async {
    final result =
        await FilePicker.platform.pickFiles(
      withData: true,
    );

    if (result == null) {
      return;
    }

    final pickedFile = result.files.single;

    if (pickedFile.bytes == null) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to read the selected file.",
          ),
        ),
      );

      return;
    }

    setState(() {
      isBusy = true;
    });

    try {
      final savedPath =
          await FileStorage.saveStaffDocument(
        pickedFile.bytes!,
        fileName: pickedFile.name,
      );

      String transcriptDocument =
          student.transcriptDocument;

      String recommendationDocument =
          student.recommendationDocument;

      String transferCertificate =
          student.transferCertificate;

      String otherDocuments =
          student.otherDocuments;

      if (documentType == "transcript") {
        transcriptDocument = savedPath;
      } else if (documentType == "recommendation") {
        recommendationDocument = savedPath;
      } else if (documentType == "transfer") {
        transferCertificate = savedPath;
      } else if (documentType == "other") {
        otherDocuments = savedPath;
      }

      final updatedStudent =
          StudentModel(
        id: student.id,
        studentID: student.studentID,
        fullName: student.fullName,
        preferredName: student.preferredName,
        dateOfBirth: student.dateOfBirth,
        gender: student.gender,
        nationality: student.nationality,
        address: student.address,
        phone: student.phone,
        schoolType: student.schoolType,
        admissionCategory:
            student.admissionCategory,
        academicYear: student.academicYear,
        admissionDate: student.admissionDate,
        studentStatus: student.studentStatus,
        classGrade: student.classGrade,
        previousSchool:
            student.previousSchool,
        previousGrade:
            student.previousGrade,
        previousAcademicYear:
            student.previousAcademicYear,
        faculty: student.faculty,
        department: student.department,
        program: student.program,
        major: student.major,
        trainingLevel:
            student.trainingLevel,
        practicalExperience:
            student.practicalExperience,
        parentGuardianName:
            student.parentGuardianName,
        parentGuardianRelationship:
            student.parentGuardianRelationship,
        parentGuardianPhone:
            student.parentGuardianPhone,
        parentGuardianEmail:
            student.parentGuardianEmail,
        parentGuardianAddress:
            student.parentGuardianAddress,
        parentGuardianOccupation:
            student.parentGuardianOccupation,
        emergencyContactName:
            student.emergencyContactName,
        emergencyContactPhone:
            student.emergencyContactPhone,
        studentPhoto:
            student.studentPhoto,
        transcriptDocument:
            transcriptDocument,
        recommendationDocument:
            recommendationDocument,
        transferCertificate:
            transferCertificate,
        otherDocuments:
            otherDocuments,

        biometricStatus:
    student.biometricStatus,

biometricReference:
    student.biometricReference,

biometricProvider:
    student.biometricProvider,

biometricEnrolledDate:
    student.biometricEnrolledDate,
      );

      await DatabaseHelper.instance.updateStudent(
        updatedStudent.toMap(),
      );

      if (currentPath.isNotEmpty &&
          currentPath != savedPath) {
        await FileStorage.deleteFile(
          currentPath,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        student = updatedStudent;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Document saved successfully.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to save document: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isBusy = false;
        });
      }
    }
  }

  // ============================================================
  // OPEN DOCUMENT
  // ============================================================

  Future<void> _openDocument(
    String filePath,
  ) async {
    if (filePath.isEmpty) {
      return;
    }

    try {
      final bytes =
          await FileStorage.readFile(
        filePath,
      );

      if (!mounted) {
        return;
      }

      if (bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "The stored document could not be found.",
            ),
          ),
        );

        return;
      }

      final fileName =
          _fileName(filePath);

      if (kIsWeb) {
        final blob = html.Blob(
          [bytes],
          _mimeType(fileName),
        );

        final url =
            html.Url.createObjectUrlFromBlob(
          blob,
        );

        html.window.open(
          url,
          '_blank',
        );

        Future.delayed(
          const Duration(seconds: 10),
          () {
            html.Url.revokeObjectUrl(
              url,
            );
          },
        );

        return;
      }

      final result =
          await OpenFilex.open(
        filePath,
      );

      if (!mounted) {
        return;
      }

      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Unable to open document: "
              "${result.message}",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not open document: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // DOWNLOAD DOCUMENT — WEB
  // ============================================================

  Future<void> _downloadDocument(
    String filePath,
  ) async {
    if (filePath.isEmpty) {
      return;
    }

    try {
      final bytes =
          await FileStorage.readFile(
        filePath,
      );

      if (!mounted) {
        return;
      }

      if (bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "The stored document could not be found.",
            ),
          ),
        );

        return;
      }

      final fileName =
          _fileName(filePath);

      if (kIsWeb) {
        final blob = html.Blob(
          [bytes],
          _mimeType(fileName),
        );

        final url =
            html.Url.createObjectUrlFromBlob(
          blob,
        );

        final anchor =
            html.AnchorElement(
          href: url,
        );

        anchor
          ..download = fileName
          ..style.display = 'none';

        html.document.body?.append(
          anchor,
        );

        anchor.click();
        anchor.remove();

        Future.delayed(
          const Duration(seconds: 2),
          () {
            html.Url.revokeObjectUrl(
              url,
            );
          },
        );

        return;
      }

      final result =
          await OpenFilex.open(
        filePath,
      );

      if (!mounted) {
        return;
      }

      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Unable to open document: "
              "${result.message}",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not download document: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // DELETE DOCUMENT
  // ============================================================

  Future<void> _deleteDocument(
    String documentType,
    String filePath,
  ) async {
    if (filePath.isEmpty) {
      return;
    }

    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Delete Document",
          ),
          content: const Text(
            "Are you sure you want to delete this document?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                "CANCEL",
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
                "DELETE",
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      isBusy = true;
    });

    try {
      String transcriptDocument =
          student.transcriptDocument;

      String recommendationDocument =
          student.recommendationDocument;

      String transferCertificate =
          student.transferCertificate;

      String otherDocuments =
          student.otherDocuments;

      if (documentType == "transcript") {
        transcriptDocument = "";
      } else if (documentType == "recommendation") {
        recommendationDocument = "";
      } else if (documentType == "transfer") {
        transferCertificate = "";
      } else if (documentType == "other") {
        otherDocuments = "";
      }

      final updatedStudent =
          StudentModel(
        id: student.id,
        studentID: student.studentID,
        fullName: student.fullName,
        preferredName: student.preferredName,
        dateOfBirth: student.dateOfBirth,
        gender: student.gender,
        nationality: student.nationality,
        address: student.address,
        phone: student.phone,
        schoolType: student.schoolType,
        admissionCategory:
            student.admissionCategory,
        academicYear: student.academicYear,
        admissionDate: student.admissionDate,
        studentStatus: student.studentStatus,
        classGrade: student.classGrade,
        previousSchool:
            student.previousSchool,
        previousGrade:
            student.previousGrade,
        previousAcademicYear:
            student.previousAcademicYear,
        faculty: student.faculty,
        department: student.department,
        program: student.program,
        major: student.major,
        trainingLevel:
            student.trainingLevel,
        practicalExperience:
            student.practicalExperience,
        parentGuardianName:
            student.parentGuardianName,
        parentGuardianRelationship:
            student.parentGuardianRelationship,
        parentGuardianPhone:
            student.parentGuardianPhone,
        parentGuardianEmail:
            student.parentGuardianEmail,
        parentGuardianAddress:
            student.parentGuardianAddress,
        parentGuardianOccupation:
            student.parentGuardianOccupation,
        emergencyContactName:
            student.emergencyContactName,
        emergencyContactPhone:
            student.emergencyContactPhone,
        studentPhoto:
            student.studentPhoto,
        transcriptDocument:
            transcriptDocument,
        recommendationDocument:
            recommendationDocument,
        transferCertificate:
            transferCertificate,
        otherDocuments:
            otherDocuments,

        biometricStatus:
    student.biometricStatus,

biometricReference:
    student.biometricReference,

biometricProvider:
    student.biometricProvider,

biometricEnrolledDate:
    student.biometricEnrolledDate,
      );

      await DatabaseHelper.instance.updateStudent(
        updatedStudent.toMap(),
      );

      await FileStorage.deleteFile(
        filePath,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        student = updatedStudent;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Document deleted successfully.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to delete document: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isBusy = false;
        });
      }
    }
  }

  // ============================================================
  // DOCUMENT CARD
  // ============================================================

  Widget _documentCard({
    required String title,
    required String documentType,
    required String filePath,
  }) {
    final hasFile =
        filePath.isNotEmpty;

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 15,
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.description,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    title,
                    style:
                        const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              hasFile
                  ? _fileName(filePath)
                  : "No document uploaded",
              style:
                  TextStyle(
                color: hasFile
                    ? Colors.black
                    : Colors.grey,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            if (hasFile)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: isBusy
                        ? null
                        : () =>
                            _openDocument(
                          filePath,
                        ),
                    icon: const Icon(
                      Icons.open_in_new,
                    ),
                    label: const Text(
                      "OPEN",
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: isBusy
                        ? null
                        : () =>
                            _downloadDocument(
                          filePath,
                        ),
                    icon: const Icon(
                      Icons.download,
                    ),
                    label: const Text(
                      "DOWNLOAD",
                    ),
                  ),
                  TextButton.icon(
                    onPressed: isBusy
                        ? null
                        : () =>
                            _replaceDocument(
                          documentType,
                          filePath,
                        ),
                    icon: const Icon(
                      Icons.upload_file,
                    ),
                    label: const Text(
                      "REPLACE",
                    ),
                  ),
                  IconButton(
                    onPressed: isBusy
                        ? null
                        : () =>
                            _deleteDocument(
                          documentType,
                          filePath,
                        ),
                    icon:
                        const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    tooltip:
                        "Delete Document",
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                onPressed: isBusy
                    ? null
                    : () =>
                        _replaceDocument(
                      documentType,
                      filePath,
                    ),
                icon: const Icon(
                  Icons.upload_file,
                ),
                label: const Text(
                  "UPLOAD DOCUMENT",
                ),
              ),
          ],
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
        title: Text(
          "${student.fullName} Documents",
        ),
        backgroundColor:
            Colors.amber,
        foregroundColor:
            Colors.black,
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  child: Text(
                    student.fullName
                            .isNotEmpty
                        ? student
                            .fullName[0]
                            .toUpperCase()
                        : "?",
                    style:
                        const TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  student.studentID,
                  style:
                      const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                _documentCard(
                  title:
                      "Transcript / Academic Record",
                  documentType:
                      "transcript",
                  filePath:
                      student.transcriptDocument,
                ),

                _documentCard(
                  title:
                      "Letter of Recommendation",
                  documentType:
                      "recommendation",
                  filePath:
                      student.recommendationDocument,
                ),

                _documentCard(
                  title:
                      "Transfer Certificate",
                  documentType:
                      "transfer",
                  filePath:
                      student.transferCertificate,
                ),

                _documentCard(
                  title:
                      "Other Document",
                  documentType:
                      "other",
                  filePath:
                      student.otherDocuments,
                ),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),

          if (isBusy)
            Container(
              color:
                  Colors.black.withValues(
                alpha: 0.15,
              ),
              child: const Center(
                child:
                    CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}