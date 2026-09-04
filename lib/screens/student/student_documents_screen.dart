import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:universal_html/html.dart' as html;

import '../../data/student_data.dart';
import '../../database/database_helper.dart';
import '../../models/student_document_model.dart';
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
  bool isLoading = true;

  String selectedDocumentType =
      "Transcript / Academic Record";

  String documentFilter =
      "All Documents";

  Uint8List? selectedFileBytes;
  String selectedFileName = "";

  List<StudentDocumentModel> documents = [];

  static const List<String>
      documentTypes = [
    "Transcript / Academic Record",
    "Letter of Recommendation",
    "Transfer Certificate",
    "Other Document",
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    student = widget.student;

    loadDocuments();
  }

  // ============================================================
  // LOAD STUDENT + DOCUMENTS
  // ============================================================

  Future<void> loadDocuments() async {
    try {
      final latestStudent =
          await DatabaseHelper.instance
              .getStudentByID(
        widget.student.studentID,
      );

      if (latestStudent != null) {
        student = StudentModel.fromMap(
          latestStudent,
        );

        StudentData.updateStudent(
          student,
        );
      }

      final data =
          await DatabaseHelper.instance
              .getStudentDocuments(
        student.studentID,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        documents = data
            .map(
              (item) =>
                  StudentDocumentModel
                      .fromMap(item),
            )
            .toList();

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Failed to load student documents: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // FILE NAME
  // ============================================================

  
  // ============================================================
  // MIME TYPE
  // ============================================================

  String _mimeType(
    String fileName,
  ) {
    final lower =
        fileName.toLowerCase();

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
  // LOAD STUDENT PHOTO
  // ============================================================

  Future<Uint8List?> _loadStudentPhoto(
    String imagePath,
  ) async {
    if (imagePath.isEmpty) {
      return null;
    }

    return FileStorage.readFile(
      imagePath,
    );
  }

  // ============================================================
  // PICK DOCUMENT
  // ============================================================

  Future<void> pickDocument() async {
    try {
      final result =
          await FilePicker.platform
              .pickFiles(
        withData: true,
      );

      if (result == null ||
          result.files.isEmpty) {
        return;
      }

      final file =
          result.files.single;

      if (file.bytes == null) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Unable to read the selected document.",
            ),
          ),
        );

        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        selectedFileBytes =
            file.bytes;

        selectedFileName =
            file.name;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Failed to choose document: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // UPDATE LEGACY STUDENT DOCUMENT FIELD
  // ============================================================

  StudentModel _studentWithLegacyDocument(
    String documentType,
    String filePath,
  ) {
    String transcript =
        student.transcriptDocument;

    String recommendation =
        student.recommendationDocument;

    String transfer =
        student.transferCertificate;

    String other =
        student.otherDocuments;

    if (documentType ==
        "Transcript / Academic Record") {
      transcript = filePath;
    } else if (documentType ==
        "Letter of Recommendation") {
      recommendation = filePath;
    } else if (documentType ==
        "Transfer Certificate") {
      transfer = filePath;
    } else if (documentType ==
        "Other Document") {
      other = filePath;
    }

    return StudentModel(
      id: student.id,
      studentID: student.studentID,
      fullName: student.fullName,
      preferredName:
          student.preferredName,
      dateOfBirth:
          student.dateOfBirth,
      gender: student.gender,
      nationality:
          student.nationality,
      address: student.address,
      phone: student.phone,
      schoolType:
          student.schoolType,
      admissionCategory:
          student.admissionCategory,
      academicYear:
          student.academicYear,
      admissionDate:
          student.admissionDate,
      studentStatus:
          student.studentStatus,
      classGrade:
          student.classGrade,
      previousSchool:
          student.previousSchool,
      previousGrade:
          student.previousGrade,
      previousAcademicYear:
          student.previousAcademicYear,
      faculty: student.faculty,
      department:
          student.department,
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

      // Preserve parent photo.
      parentPhoto:
          student.parentPhoto,

      emergencyContactName:
          student.emergencyContactName,

      emergencyContactPhone:
          student.emergencyContactPhone,

      studentPhoto:
          student.studentPhoto,

      transcriptDocument:
          transcript,

      recommendationDocument:
          recommendation,

      transferCertificate:
          transfer,

      otherDocuments:
          other,

      biometricStatus:
          student.biometricStatus,

      biometricReference:
          student.biometricReference,

      biometricProvider:
          student.biometricProvider,

      biometricEnrolledDate:
          student.biometricEnrolledDate,
    );
  }

  // ============================================================
  // ADD DOCUMENT
  // ============================================================

  Future<void> addDocument() async {
    if (selectedFileBytes == null ||
        selectedFileName.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please choose a document first.",
          ),
        ),
      );

      return;
    }

    setState(() {
      isBusy = true;
    });

    String savedPath = "";

    try {
      savedPath =
          await FileStorage.saveStaffDocument(
        selectedFileBytes!,
        fileName:
            selectedFileName,
      );

      final now =
          DateTime.now()
              .toIso8601String();

      final document =
          StudentDocumentModel(
        studentID:
            student.studentID,
        documentType:
            selectedDocumentType,
        documentName:
            selectedFileName,
        filePath:
            savedPath,
        uploadDate: now,
      );

      // --------------------------------------------------------
      // SAVE DOCUMENT RECORD
      // --------------------------------------------------------

      await DatabaseHelper.instance
          .insertStudentDocument(
        document.toMap(),
      );

      // --------------------------------------------------------
      // MAINTAIN LEGACY FIELD
      // --------------------------------------------------------

      final updatedStudent =
          _studentWithLegacyDocument(
        selectedDocumentType,
        savedPath,
      );

      await DatabaseHelper.instance
          .updateStudent(
        updatedStudent.toMap(),
      );

      StudentData.updateStudent(
        updatedStudent,
      );

      // --------------------------------------------------------
      // RELOAD
      // --------------------------------------------------------

      final latestDocuments =
          await DatabaseHelper.instance
              .getStudentDocuments(
        updatedStudent.studentID,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        student =
            updatedStudent;

        documents =
            latestDocuments
                .map(
                  (item) =>
                      StudentDocumentModel
                          .fromMap(item),
                )
                .toList();

        selectedFileBytes = null;

        selectedFileName = "";
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Document added successfully.",
          ),
        ),
      );
    } catch (e) {
      if (savedPath.isNotEmpty) {
        try {
          await FileStorage.deleteFile(
            savedPath,
          );
        } catch (_) {
          // Ignore cleanup failure.
        }
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Failed to add document: $e",
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
  // REPLACE DOCUMENT
  // ============================================================

  Future<void> replaceDocument(
    StudentDocumentModel document,
  ) async {
    final result =
        await FilePicker.platform
            .pickFiles(
      withData: true,
    );

    if (result == null ||
        result.files.isEmpty) {
      return;
    }

    final file =
        result.files.single;

    if (file.bytes == null) {
      return;
    }

    setState(() {
      isBusy = true;
    });

    String savedPath = "";

    try {
      savedPath =
          await FileStorage.saveStaffDocument(
        file.bytes!,
        fileName:
            file.name,
      );

      final updatedDocument =
          StudentDocumentModel(
        id: document.id,
        studentID:
            document.studentID,
        documentType:
            document.documentType,
        documentName:
            file.name,
        filePath:
            savedPath,
        uploadDate:
            DateTime.now()
                .toIso8601String(),
      );

      await DatabaseHelper.instance
          .updateStudentDocument(
        updatedDocument.toMap(),
      );

      // Update legacy field only when
      // this document was the currently
      // referenced legacy document.
      final legacyPath =
          _legacyPathForType(
        document.documentType,
      );

      if (legacyPath ==
          document.filePath) {
        final updatedStudent =
            _studentWithLegacyDocument(
          document.documentType,
          savedPath,
        );

        await DatabaseHelper.instance
            .updateStudent(
          updatedStudent.toMap(),
        );

        student =
            updatedStudent;

        StudentData.updateStudent(
          updatedStudent,
        );
      }

      await FileStorage.deleteFile(
        document.filePath,
      );

      await loadDocuments();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Document replaced successfully.",
          ),
        ),
      );
    } catch (e) {
      if (savedPath.isNotEmpty) {
        try {
          await FileStorage.deleteFile(
            savedPath,
          );
        } catch (_) {
          // Ignore cleanup failure.
        }
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Failed to replace document: $e",
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
  // LEGACY PATH
  // ============================================================

  String _legacyPathForType(
    String documentType,
  ) {
    switch (documentType) {
      case "Transcript / Academic Record":
        return student.transcriptDocument;

      case "Letter of Recommendation":
        return student.recommendationDocument;

      case "Transfer Certificate":
        return student.transferCertificate;

      case "Other Document":
        return student.otherDocuments;

      default:
        return "";
    }
  }

  // ============================================================
  // OPEN
  // ============================================================

  Future<void> openDocument(
    StudentDocumentModel document,
  ) async {
    try {
      final bytes =
          await FileStorage.readFile(
        document.filePath,
      );

      if (!mounted) {
        return;
      }

      if (bytes == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "The stored document could not be found.",
            ),
          ),
        );

        return;
      }

      if (kIsWeb) {
        final blob = html.Blob(
          [
            bytes,
          ],
          _mimeType(
            document.documentName,
          ),
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
        document.filePath,
      );

      if (!mounted) {
        return;
      }

      if (result.type !=
          ResultType.done) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
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

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Could not open document: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // DOWNLOAD
  // ============================================================

  Future<void> downloadDocument(
    StudentDocumentModel document,
  ) async {
    try {
      final bytes =
          await FileStorage.readFile(
        document.filePath,
      );

      if (!mounted) {
        return;
      }

      if (bytes == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "The stored document could not be found.",
            ),
          ),
        );

        return;
      }

      if (kIsWeb) {
        final blob = html.Blob(
          [
            bytes,
          ],
          _mimeType(
            document.documentName,
          ),
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
          ..download =
              document.documentName
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
        document.filePath,
      );

      if (!mounted) {
        return;
      }

      if (result.type !=
          ResultType.done) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              "Unable to download document: "
              "${result.message}",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Could not download document: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> deleteDocument(
    StudentDocumentModel document,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Delete Document",
          ),
          content: Text(
            "Are you sure you want to delete\n\n"
            "${document.documentName}?",
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
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                "DELETE",
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true ||
        document.id == null) {
      return;
    }

    setState(() {
      isBusy = true;
    });

    try {
      await DatabaseHelper.instance
          .deleteStudentDocument(
        document.id!,
      );

      await FileStorage.deleteFile(
        document.filePath,
      );

      // --------------------------------------------------------
      // UPDATE LEGACY FIELD WHEN NECESSARY
      // --------------------------------------------------------

      final legacyPath =
          _legacyPathForType(
        document.documentType,
      );

      if (legacyPath ==
          document.filePath) {
        final remaining =
            await DatabaseHelper.instance
                .getStudentDocuments(
          student.studentID,
        );

        final sameType =
            remaining.where(
          (item) =>
              (item['documentType'] ??
                  '') ==
              document.documentType,
        );

        String fallbackPath = "";

        if (sameType.isNotEmpty) {
          fallbackPath =
              sameType.first[
                  'filePath'] ??
              "";
        }

        final updatedStudent =
            _studentWithLegacyDocument(
          document.documentType,
          fallbackPath,
        );

        await DatabaseHelper.instance
            .updateStudent(
          updatedStudent.toMap(),
        );

        StudentData.updateStudent(
          updatedStudent,
        );

        student =
            updatedStudent;
      }

      await loadDocuments();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
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

      ScaffoldMessenger.of(context)
          .showSnackBar(
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

  Widget documentCard(
    StudentDocumentModel document,
  ) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
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
                    document.documentType,
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
              height: 8,
            ),

            Text(
              document.documentName,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.w500,
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            Text(
              "Uploaded: "
              "${document.uploadDate}",
              style:
                  const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: isBusy
                      ? null
                      : () =>
                          openDocument(
                        document,
                      ),
                  icon: const Icon(
                    Icons.open_in_new,
                  ),
                  label:
                      const Text(
                    "OPEN",
                  ),
                ),

                OutlinedButton.icon(
                  onPressed: isBusy
                      ? null
                      : () =>
                          downloadDocument(
                        document,
                      ),
                  icon: const Icon(
                    Icons.download,
                  ),
                  label:
                      const Text(
                    "DOWNLOAD",
                  ),
                ),

                TextButton.icon(
                  onPressed: isBusy
                      ? null
                      : () =>
                          replaceDocument(
                        document,
                      ),
                  icon: const Icon(
                    Icons.upload_file,
                  ),
                  label:
                      const Text(
                    "REPLACE",
                  ),
                ),

                IconButton(
                  onPressed: isBusy
                      ? null
                      : () =>
                          deleteDocument(
                        document,
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
    if (isLoading) {
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
        body: const Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    final filteredDocuments =
        documentFilter ==
                "All Documents"
            ? documents
            : documents
                .where(
                  (document) =>
                      document
                          .documentType ==
                      documentFilter,
                )
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${student.fullName} Documents",
        ),
        backgroundColor:
            Colors.amber,
        foregroundColor:
            Colors.black,
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(
              right: 16,
            ),
            child: Center(
              child: Text(
                "${documents.length} Documents",
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ==================================================
                // STUDENT PHOTO
                // ==================================================

                Center(
                  child:
                      FutureBuilder<
                          Uint8List?>(
                    future:
                        _loadStudentPhoto(
                      student.studentPhoto,
                    ),
                    builder: (
                      context,
                      snapshot,
                    ) {
                      final bytes =
                          snapshot.data;

                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor:
                                Colors.amber.shade100,
                            backgroundImage:
                                bytes != null
                                    ? MemoryImage(
                                        bytes,
                                      )
                                    : null,
                            child: bytes ==
                                    null
                                ? Text(
                                    student
                                            .fullName
                                            .isNotEmpty
                                        ? student
                                            .fullName[0]
                                            .toUpperCase()
                                        : "?",
                                    style:
                                        const TextStyle(
                                      fontSize:
                                          36,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            student.fullName,
                            style:
                                const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            student.studentID,
                            style:
                                const TextStyle(
                              color:
                                  Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // ==================================================
                // ADD DOCUMENT
                // ==================================================

                const Text(
                  "Add Document",
                  style:
                      TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                DropdownButtonFormField<
                    String>(
                  initialValue:
                      selectedDocumentType,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Document Type",
                    border:
                        OutlineInputBorder(),
                    prefixIcon:
                        Icon(
                      Icons.description,
                    ),
                  ),
                  items:
                      documentTypes
                          .map(
                            (
                              type,
                            ) =>
                                DropdownMenuItem<
                                    String>(
                              value: type,
                              child:
                                  Text(
                                type,
                              ),
                            ),
                          )
                          .toList(),
                  onChanged:
                      isBusy
                          ? null
                          : (
                              value,
                            ) {
                              if (value ==
                                  null) {
                                return;
                              }

                              setState(() {
                                selectedDocumentType =
                                    value;
                              });
                            },
                ),

                const SizedBox(
                  height: 12,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  child:
                      OutlinedButton.icon(
                    onPressed:
                        isBusy
                            ? null
                            : pickDocument,
                    icon:
                        const Icon(
                      Icons.attach_file,
                    ),
                    label:
                        const Text(
                      "CHOOSE DOCUMENT",
                    ),
                  ),
                ),

                if (selectedFileName
                    .isNotEmpty) ...[
                  const SizedBox(
                    height: 10,
                  ),

                  Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets
                            .all(12),
                    decoration:
                        BoxDecoration(
                      border:
                          Border.all(
                        color:
                            Colors.blue,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        8,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description,
                          color:
                              Colors.blue,
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child:
                              Text(
                            selectedFileName,
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed:
                              isBusy
                                  ? null
                                  : () {
                                      setState(() {
                                        selectedFileBytes =
                                            null;
                                        selectedFileName =
                                            "";
                                      });
                                    },
                          icon:
                              const Icon(
                            Icons.close,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(
                  height: 10,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  height: 52,
                  child:
                      ElevatedButton.icon(
                    onPressed:
                        isBusy
                            ? null
                            : addDocument,
                    icon:
                        const Icon(
                      Icons.upload_file,
                    ),
                    label:
                        const Text(
                      "ADD DOCUMENT",
                      style:
                          TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          Colors.amber,
                      foregroundColor:
                          Colors.black,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // ==================================================
                // FILTER
                // ==================================================

                const Text(
                  "Document Filter",
                  style:
                      TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                DropdownButtonFormField<
                    String>(
                  initialValue:
                      documentFilter,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Filter Documents",
                    border:
                        OutlineInputBorder(),
                    prefixIcon:
                        Icon(
                      Icons.filter_list,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value:
                          "All Documents",
                      child: Text(
                        "All Documents",
                      ),
                    ),
                    DropdownMenuItem(
                      value:
                          "Transcript / Academic Record",
                      child: Text(
                        "Transcript / Academic Record",
                      ),
                    ),
                    DropdownMenuItem(
                      value:
                          "Letter of Recommendation",
                      child: Text(
                        "Letter of Recommendation",
                      ),
                    ),
                    DropdownMenuItem(
                      value:
                          "Transfer Certificate",
                      child: Text(
                        "Transfer Certificate",
                      ),
                    ),
                    DropdownMenuItem(
                      value:
                          "Other Document",
                      child: Text(
                        "Other Document",
                      ),
                    ),
                  ],
                  onChanged:
                      isBusy
                          ? null
                          : (
                              value,
                            ) {
                              if (value ==
                                  null) {
                                return;
                              }

                              setState(() {
                                documentFilter =
                                    value;
                              });
                            },
                ),

                const SizedBox(
                  height: 25,
                ),

                // ==================================================
                // DOCUMENT LIST
                // ==================================================

                if (filteredDocuments
                    .isEmpty)
                  Center(
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 30,
                        ),
                        Icon(
                          Icons
                              .description_outlined,
                          size: 64,
                          color:
                              Colors.grey,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "No Documents Found",
                          style:
                              TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...filteredDocuments.map(
                    documentCard,
                  ),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),

          // ========================================================
          // BUSY
          // ========================================================

          if (isBusy)
            Container(
              color:
                  Colors.black.withValues(
                alpha: 0.15,
              ),
              child:
                  const Center(
                child:
                    CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}