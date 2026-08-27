import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/student_data.dart';
import '../../database/database_helper.dart';
import '../../models/student_model.dart';
import '../../utils/file_storage.dart';

class StudentRegistrationScreen extends StatefulWidget {
  const StudentRegistrationScreen({
    super.key,
  });

  @override
  State<StudentRegistrationScreen> createState() =>
      _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState
    extends State<StudentRegistrationScreen> {
  final formKey = GlobalKey<FormState>();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final fullNameController = TextEditingController();
  final preferredNameController = TextEditingController();
  final nationalityController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  final classGradeController = TextEditingController();

  final previousSchoolController =
      TextEditingController();

  final previousGradeController =
      TextEditingController();

  final previousAcademicYearController =
      TextEditingController();

  final facultyController =
      TextEditingController();

  final departmentController =
      TextEditingController();

  final programController =
      TextEditingController();

  final majorController =
      TextEditingController();

  final trainingLevelController =
      TextEditingController();

  final practicalExperienceController =
      TextEditingController();

  final existingStudentIDController =
      TextEditingController();

  final previousPrimaryClassController =
      TextEditingController();

  final pickupAuthorizationController =
      TextEditingController();

  final careInstructionsController =
      TextEditingController();

  final parentGuardianNameController =
      TextEditingController();

  final parentGuardianRelationshipController =
      TextEditingController();

  final parentGuardianPhoneController =
      TextEditingController();

  final parentGuardianEmailController =
      TextEditingController();

  final parentGuardianAddressController =
      TextEditingController();

  final parentGuardianOccupationController =
      TextEditingController();

  final emergencyContactNameController =
      TextEditingController();

  final emergencyContactPhoneController =
      TextEditingController();

  // ============================================================
  // SELECTIONS
  // ============================================================

  String selectedSchoolType =
      "Primary School";

  String selectedAdmissionCategory =
      "New Student";

  String selectedGender = "Male";

  String selectedStudentStatus =
      "Pending";

  String academicYear =
      "2026/2027";

  String dateOfBirth = "";

  String admissionDate = "";

  // ============================================================
  // CHAMPIONONE STUDENT ID
  // ============================================================

  bool? hasPreviousChampionOneID;

  String generatedStudentID = "";

  // ============================================================
  // BIOMETRIC
  // ============================================================

  String biometricStatus =
      "Not Enrolled";

  String biometricReference = "";

  String biometricProvider = "";

  String biometricEnrolledDate = "";

  // ============================================================
  // FILES
  // ============================================================

  Uint8List? studentPhotoBytes;
  String studentPhotoName = "";

  // Parent / Guardian photo
  Uint8List? parentPhotoBytes;
  String parentPhotoName = "";

  Uint8List? transcriptBytes;
  String transcriptName = "";

  Uint8List? recommendationBytes;
  String recommendationName = "";

  Uint8List? transferCertificateBytes;
  String transferCertificateName = "";

  Uint8List? otherDocumentBytes;
  String otherDocumentName = "";

  bool isSaving = false;

  // ============================================================
  // SCHOOL TYPES
  // ============================================================

  static const List<String> schoolTypes = [
    "Daycare / Early Childhood Education",
    "Primary School",
    "Primary → Secondary School",
    "Secondary School",
    "College",
    "University",
    "Vocational / Technical Training Institute",
  ];

  static const List<String> admissionCategories = [
    "New Student",
    "Transfer Student",
    "Returning Student",
    "Promotion / Internal Progression",
    "Graduate / Advanced Entry",
  ];

  static const List<String> genders = [
    "Male",
    "Female",
    "Other",
  ];

  static const List<String> studentStatuses = [
    "Pending",
    "Active",
    "Suspended",
    "Graduated",
    "Withdrawn",
  ];

  // ============================================================
  // SCHOOL TYPE HELPERS
  // ============================================================

  bool get isEarlyChildhood =>
      selectedSchoolType ==
      "Daycare / Early Childhood Education";

  bool get isPrimary =>
      selectedSchoolType ==
      "Primary School";

  bool get isPrimarySecondary =>
      selectedSchoolType ==
      "Primary → Secondary School";

  bool get isSecondary =>
      selectedSchoolType ==
      "Secondary School";

  bool get isCollege =>
      selectedSchoolType ==
      "College";

  bool get isUniversity =>
      selectedSchoolType ==
      "University";

  bool get isVocational =>
      selectedSchoolType ==
      "Vocational / Technical Training Institute";

  bool get showHigherEducation =>
      isCollege || isUniversity;

  bool get showRecommendation =>
      isSecondary ||
      isCollege ||
      isUniversity ||
      isVocational;

  bool get showTranscript =>
      isSecondary ||
      isCollege ||
      isUniversity ||
      isVocational;

  // ============================================================
  // INITIALIZE
  // ============================================================

  @override
  void initState() {
    super.initState();

    generatedStudentID =
        generateStudentID();
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

    existingStudentIDController.dispose();
    previousPrimaryClassController.dispose();

    pickupAuthorizationController.dispose();
    careInstructionsController.dispose();

    parentGuardianNameController.dispose();
    parentGuardianRelationshipController.dispose();
    parentGuardianPhoneController.dispose();
    parentGuardianEmailController.dispose();
    parentGuardianAddressController.dispose();
    parentGuardianOccupationController.dispose();

    emergencyContactNameController.dispose();
    emergencyContactPhoneController.dispose();
    emergencyContactPhoneController.dispose();

    super.dispose();
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> pickDate({
    required bool dateOfBirthField,
  }) async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,

      // Allow historical birth dates.
      firstDate: DateTime(
        1900,
        1,
        1,
      ),

      // Never allow future dates.
      lastDate: now,

      // Start DOB picker around 18 years ago.
      initialDate: dateOfBirthField
          ? DateTime(
              now.year - 18,
              now.month,
              now.day,
            )
          : now,
    );

    if (selected == null) {
      return;
    }

    final formatted =
        "${selected.year.toString().padLeft(4, '0')}-"
        "${selected.month.toString().padLeft(2, '0')}-"
        "${selected.day.toString().padLeft(2, '0')}";

    if (!mounted) {
      return;
    }

    setState(() {
      if (dateOfBirthField) {
        dateOfBirth = formatted;
      } else {
        admissionDate = formatted;
      }
    });
  }

  // ============================================================
  // STUDENT PHOTO
  // ============================================================

  Future<void> pickPhoto() async {
    final result =
        await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null) {
      return;
    }

    final file = result.files.single;

    if (file.bytes == null) {
      if (!mounted) {
        return;
      }

      showMessage(
        "Unable to read the selected student photo.",
      );

      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      studentPhotoBytes = file.bytes;
      studentPhotoName = file.name;
    });
  }

  // ============================================================
  // PARENT / GUARDIAN PHOTO
  // ============================================================

  Future<void> pickParentPhoto() async {
    final result =
        await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null) {
      return;
    }

    final file = result.files.single;

    if (file.bytes == null) {
      if (!mounted) {
        return;
      }

      showMessage(
        "Unable to read the selected parent photo.",
      );

      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      parentPhotoBytes = file.bytes;
      parentPhotoName = file.name;
    });
  }

  // ============================================================
  // DOCUMENT PICKER
  // ============================================================

  Future<void> pickDocument({
    required String documentType,
  }) async {
    final result =
        await FilePicker.platform.pickFiles(
      withData: true,
    );

    if (result == null) {
      return;
    }

    final file = result.files.single;

    if (file.bytes == null) {
      if (!mounted) {
        return;
      }

      showMessage(
        "Unable to read the selected document.",
      );

      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      switch (documentType) {
        case "transcript":
          transcriptBytes = file.bytes;
          transcriptName = file.name;
          break;

        case "recommendation":
          recommendationBytes = file.bytes;
          recommendationName =
              file.name;
          break;

        case "transfer":
          transferCertificateBytes =
              file.bytes;
          transferCertificateName =
              file.name;
          break;

        default:
          otherDocumentBytes =
              file.bytes;
          otherDocumentName =
              file.name;
      }
    });
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void showMessage(
    String message,
  ) {
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
  // STUDENT ID
  // ============================================================

  String generateStudentID() {
    final timestamp =
        DateTime.now()
            .millisecondsSinceEpoch;

    return "STU-$timestamp";
  }

  String resolveStudentID() {
    if (hasPreviousChampionOneID ==
        true) {
      final previousID =
          existingStudentIDController
              .text
              .trim();

      if (previousID.isNotEmpty) {
        return previousID;
      }
    }

    if (generatedStudentID.isEmpty) {
      generatedStudentID =
          generateStudentID();
    }

    return generatedStudentID;
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool validateApplication() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (dateOfBirth.isEmpty) {
      showMessage(
        "Please select the student's date of birth.",
      );

      return false;
    }

    if (admissionDate.isEmpty) {
      showMessage(
        "Please select the admission date.",
      );

      return false;
    }

    // ----------------------------------------------------------
    // NEW STUDENT
    // ----------------------------------------------------------

    if (selectedAdmissionCategory ==
        "New Student") {
      if (hasPreviousChampionOneID ==
          null) {
        showMessage(
          "Please indicate whether the student has a previous ChampionOne ID.",
        );

        return false;
      }

      if (hasPreviousChampionOneID ==
              true &&
          existingStudentIDController
              .text
              .trim()
              .isEmpty) {
        showMessage(
          "Please enter the previous ChampionOne Student ID.",
        );

        return false;
      }
    }

    // ----------------------------------------------------------
    // RETURNING / PROMOTION
    // ----------------------------------------------------------

    if (selectedAdmissionCategory ==
            "Returning Student" ||
        selectedAdmissionCategory ==
            "Promotion / Internal Progression") {
      if (existingStudentIDController
          .text
          .trim()
          .isEmpty) {
        showMessage(
          "Please enter the student's existing ChampionOne ID.",
        );

        return false;
      }
    }

    return true;
  }

  // ============================================================
  // REVIEW
  // ============================================================

  Future<void> reviewApplication() async {
    if (!validateApplication()) {
      return;
    }

    final studentID =
        resolveStudentID();

    final draft =
        _buildReviewData(
      studentID,
    );

    final confirmed =
        await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StudentApplicationReviewScreen(
          data: draft,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    if (confirmed == true) {
      await saveStudent(
        studentID,
      );
    }
  }

  // ============================================================
  // REVIEW DATA
  // ============================================================

  Map<String, dynamic>
      _buildReviewData(
    String studentID,
  ) {
    return {
      "schoolType":
          selectedSchoolType,

      "admissionCategory":
          selectedAdmissionCategory,

      "studentID":
          studentID,

      "fullName":
          fullNameController
              .text
              .trim(),

      "preferredName":
          preferredNameController
              .text
              .trim(),

      "dateOfBirth":
          dateOfBirth,

      "gender":
          selectedGender,

      "nationality":
          nationalityController
              .text
              .trim(),

      "address":
          addressController
              .text
              .trim(),

      "phone":
          phoneController
              .text
              .trim(),

      "academicYear":
          academicYear,

      "admissionDate":
          admissionDate,

      "studentStatus":
          selectedStudentStatus,

      "classGrade":
          classGradeController
              .text
              .trim(),

      "previousSchool":
          previousSchoolController
              .text
              .trim(),

      "previousGrade":
          previousGradeController
              .text
              .trim(),

      "previousAcademicYear":
          previousAcademicYearController
              .text
              .trim(),

      "faculty":
          facultyController
              .text
              .trim(),

      "department":
          departmentController
              .text
              .trim(),

      "program":
          programController
              .text
              .trim(),

      "major":
          majorController
              .text
              .trim(),

      "trainingLevel":
          trainingLevelController
              .text
              .trim(),

      "practicalExperience":
          practicalExperienceController
              .text
              .trim(),

      "parentGuardianName":
          parentGuardianNameController
              .text
              .trim(),

      "parentGuardianRelationship":
          parentGuardianRelationshipController
              .text
              .trim(),

      "parentGuardianPhone":
          parentGuardianPhoneController
              .text
              .trim(),

      "parentGuardianEmail":
          parentGuardianEmailController
              .text
              .trim(),

      "parentGuardianAddress":
          parentGuardianAddressController
              .text
              .trim(),

      "parentGuardianOccupation":
          parentGuardianOccupationController
              .text
              .trim(),

      "emergencyContactName":
          emergencyContactNameController
              .text
              .trim(),

      "emergencyContactPhone":
          emergencyContactPhoneController
              .text
              .trim(),

      "previousPrimaryClass":
          previousPrimaryClassController
              .text
              .trim(),

      "pickupAuthorization":
          pickupAuthorizationController
              .text
              .trim(),

      "careInstructions":
          careInstructionsController
              .text
              .trim(),

      "studentPhoto":
          studentPhotoName,

      "parentPhoto":
          parentPhotoName,

      "transcript":
          transcriptName,

      "recommendation":
          recommendationName,

      "transferCertificate":
          transferCertificateName,

      "otherDocument":
          otherDocumentName,

      "biometricStatus":
          biometricStatus,
    };
  }

  // ============================================================
  // SAVE STUDENT
  // ============================================================

  Future<void> saveStudent(
    String studentID,
  ) async {
    if (isSaving) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      String studentPhotoPath = "";
      String parentPhotoPath = "";

      String transcriptPath = "";
      String recommendationPath = "";
      String transferPath = "";
      String otherDocumentPath = "";

      // --------------------------------------------------------
      // STUDENT PHOTO
      // --------------------------------------------------------

      if (studentPhotoBytes != null) {
        studentPhotoPath =
            await FileStorage.saveStaffPhoto(
          studentPhotoBytes!,
          fileName:
              studentPhotoName,
        );
      }

      // --------------------------------------------------------
      // PARENT / GUARDIAN PHOTO
      // --------------------------------------------------------

      if (parentPhotoBytes != null) {
        parentPhotoPath =
            await FileStorage.saveStaffPhoto(
          parentPhotoBytes!,
          fileName:
              parentPhotoName,
        );
      }

      // --------------------------------------------------------
      // TRANSCRIPT
      // --------------------------------------------------------

      if (transcriptBytes != null) {
        transcriptPath =
            await FileStorage.saveStaffDocument(
          transcriptBytes!,
          fileName:
              transcriptName,
        );
      }

      // --------------------------------------------------------
      // RECOMMENDATION
      // --------------------------------------------------------

      if (recommendationBytes != null) {
        recommendationPath =
            await FileStorage.saveStaffDocument(
          recommendationBytes!,
          fileName:
              recommendationName,
        );
      }

      // --------------------------------------------------------
      // TRANSFER
      // --------------------------------------------------------

      if (transferCertificateBytes !=
          null) {
        transferPath =
            await FileStorage.saveStaffDocument(
          transferCertificateBytes!,
          fileName:
              transferCertificateName,
        );
      }

      // --------------------------------------------------------
      // OTHER DOCUMENT
      // --------------------------------------------------------

      if (otherDocumentBytes != null) {
        otherDocumentPath =
            await FileStorage.saveStaffDocument(
          otherDocumentBytes!,
          fileName:
              otherDocumentName,
        );
      }

      // --------------------------------------------------------
      // STUDENT MODEL
      // --------------------------------------------------------

      final student =
          StudentModel(
        studentID:
            studentID,

        fullName:
            fullNameController
                .text
                .trim(),

        preferredName:
            preferredNameController
                .text
                .trim(),

        dateOfBirth:
            dateOfBirth,

        gender:
            selectedGender,

        nationality:
            nationalityController
                .text
                .trim(),

        address:
            addressController
                .text
                .trim(),

        phone:
            phoneController
                .text
                .trim(),

        schoolType:
            selectedSchoolType,

        admissionCategory:
            selectedAdmissionCategory,

        academicYear:
            academicYear,

        admissionDate:
            admissionDate,

        studentStatus:
            selectedStudentStatus,

        classGrade:
            classGradeController
                .text
                .trim(),

        previousSchool:
            previousSchoolController
                .text
                .trim(),

        previousGrade:
            previousGradeController
                .text
                .trim(),

        previousAcademicYear:
            previousAcademicYearController
                .text
                .trim(),

        faculty:
            facultyController
                .text
                .trim(),

        department:
            departmentController
                .text
                .trim(),

        program:
            programController
                .text
                .trim(),

        major:
            majorController
                .text
                .trim(),

        trainingLevel:
            trainingLevelController
                .text
                .trim(),

        practicalExperience:
            practicalExperienceController
                .text
                .trim(),

        parentGuardianName:
            parentGuardianNameController
                .text
                .trim(),

        parentGuardianRelationship:
            parentGuardianRelationshipController
                .text
                .trim(),

        parentGuardianPhone:
            parentGuardianPhoneController
                .text
                .trim(),

        parentGuardianEmail:
            parentGuardianEmailController
                .text
                .trim(),

        parentGuardianAddress:
            parentGuardianAddressController
                .text
                .trim(),

        parentGuardianOccupation:
            parentGuardianOccupationController
                .text
                .trim(),

        emergencyContactName:
            emergencyContactNameController
                .text
                .trim(),

        emergencyContactPhone:
            emergencyContactPhoneController
                .text
                .trim(),

        // ------------------------------------------------------
        // PARENT PHOTO
        // ------------------------------------------------------

        parentPhoto:
            parentPhotoPath,

        // ------------------------------------------------------
        // STUDENT PHOTO
        // ------------------------------------------------------

        studentPhoto:
            studentPhotoPath,

        // ------------------------------------------------------
        // DOCUMENTS
        // ------------------------------------------------------

        transcriptDocument:
            transcriptPath,

        recommendationDocument:
            recommendationPath,

        transferCertificate:
            transferPath,

        otherDocuments:
            otherDocumentPath,

        // ------------------------------------------------------
        // BIOMETRIC
        // ------------------------------------------------------

        biometricStatus:
            biometricStatus,

        biometricReference:
            biometricReference,

        biometricProvider:
            biometricProvider,

        biometricEnrolledDate:
            biometricEnrolledDate,
      );

      // --------------------------------------------------------
      // DATABASE
      // --------------------------------------------------------

      await DatabaseHelper.instance
          .insertStudent(
        student.toMap(),
      );

      // --------------------------------------------------------
      // MEMORY
      // --------------------------------------------------------

      StudentData.addStudent(
        student,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Student registered successfully.",
          ),
        ),
      );

      Navigator.of(context).pop(
        student,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Failed to register student: $e",
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
  // TEXT FIELD
  // ============================================================

  Widget textField({
    required TextEditingController
        controller,
    required String label,
    bool requiredField = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType:
          keyboardType,
      maxLines: maxLines,

      validator: requiredField
          ? (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return "$label is required";
              }

              return null;
            }
          : null,

      decoration:
          InputDecoration(
        labelText: label,
        border:
            const OutlineInputBorder(),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget sectionTitle(
    String title,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: Align(
        alignment:
            Alignment.centerLeft,

        child: Text(
          title,
          style:
              const TextStyle(
            fontSize: 20,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SPACING
  // ============================================================

  Widget spacing() {
    return const SizedBox(
      height: 15,
    );
  }

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<
            String?>
        onChanged,
  }) {
    return DropdownButtonFormField<
        String>(
      initialValue:
          value,

      decoration:
          InputDecoration(
        labelText:
            label,
        border:
            const OutlineInputBorder(),
      ),

      items: items
          .map(
            (item) =>
                DropdownMenuItem<
                    String>(
              value: item,
              child:
                  Text(item),
            ),
          )
          .toList(),

      onChanged:
          onChanged,
    );
  }

  // ============================================================
  // DATE FIELD
  // ============================================================

  Widget dateField({
    required String label,
    required String value,
    required VoidCallback
        onTap,
  }) {
    return TextFormField(
      readOnly: true,

      key: ValueKey(
        "$label-$value",
      ),

      controller:
          TextEditingController(
        text: value,
      ),

      onTap: onTap,

      validator: (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return "$label is required";
        }

        return null;
      },

      decoration:
          InputDecoration(
        labelText:
            label,
        border:
            const OutlineInputBorder(),
        suffixIcon:
            const Icon(
          Icons.calendar_today,
        ),
      ),
    );
  }

  // ============================================================
  // FILE FIELD
  // ============================================================

  Widget filePickerField({
    required String label,
    required String fileName,
    required VoidCallback
        onPressed,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,

      children: [
        Text(
          label,
          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        OutlinedButton.icon(
          onPressed:
              onPressed,

          icon:
              const Icon(
            Icons.attach_file,
          ),

          label:
              Text(
            fileName.isEmpty
                ? "Choose File"
                : fileName,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PHOTO PREVIEW
  // ============================================================

  Widget photoPreview({
    required String title,
    required Uint8List?
        imageBytes,
    required String fileName,
    required VoidCallback
        onChoose,
  }) {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        15,
      ),

      decoration:
          BoxDecoration(
        border:
            Border.all(
          color:
              Colors.blue,
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
            title,
            style:
                const TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Center(
            child:
                Container(
              width: 150,
              height: 150,

              decoration:
                  BoxDecoration(
                border:
                    Border.all(
                  color:
                      Colors.grey,
                ),

                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),

              child:
                  imageBytes != null
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),

                          child:
                              Image.memory(
                            imageBytes,
                            width:
                                150,
                            height:
                                150,
                            fit:
                                BoxFit.cover,
                          ),
                        )
                      : const Center(
                          child:
                              Icon(
                            Icons.person,
                            size: 70,
                            color:
                                Colors.grey,
                          ),
                        ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Center(
            child: Text(
              fileName.isEmpty
                  ? "No photo selected"
                  : fileName,

              textAlign:
                  TextAlign.center,

              overflow:
                  TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          SizedBox(
            width:
                double.infinity,

            child:
                OutlinedButton.icon(
              onPressed:
                  onChoose,

              icon:
                  const Icon(
                Icons.photo_camera,
              ),

              label:
                  Text(
                imageBytes == null
                    ? "CHOOSE PHOTO"
                    : "CHANGE PHOTO",
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BIOMETRIC PANEL
  // ============================================================

  Widget biometricPanel() {
    final bool enrolled =
        biometricStatus ==
            "Enrolled";

    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        15,
      ),

      decoration:
          BoxDecoration(
        border:
            Border.all(
          color: enrolled
              ? Colors.green
              : Colors.blue,
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
          Row(
            children: [
              Icon(
                Icons.fingerprint,
                size: 40,
                color: enrolled
                    ? Colors.green
                    : Colors.blue,
              ),

              const SizedBox(
                width: 10,
              ),

              const Expanded(
                child: Text(
                  "Fingerprint / Biometric",
                  style: TextStyle(
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
            "Status: $biometricStatus",
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              color: enrolled
                  ? Colors.green
                  : Colors.orange,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Text(
            enrolled
                ? "Fingerprint enrolled and ready for verification."
                : "No fingerprint enrolled yet.",

            style:
                const TextStyle(
              color:
                  Colors.grey,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          SizedBox(
            width:
                double.infinity,

            child:
                ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger
                    .of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Fingerprint scanner enrollment will be connected here.",
                    ),
                  ),
                );
              },

              icon:
                  const Icon(
                Icons.fingerprint,
              ),

              label:
                  Text(
                enrolled
                    ? "MANAGE FINGERPRINT"
                    : "ENROLL FINGERPRINT",
              ),

              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    Colors.blue,
                foregroundColor:
                    Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHAMPIONONE ID SECTION
  // ============================================================

  Widget championOneIDSection() {
    final showIDSection =
        selectedAdmissionCategory ==
                "New Student" ||
            selectedAdmissionCategory ==
                "Returning Student" ||
            selectedAdmissionCategory ==
                "Promotion / Internal Progression";

    if (!showIDSection) {
      return const SizedBox
          .shrink();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,

      children: [
        sectionTitle(
          "ChampionOne Student ID",
        ),

        const Text(
          "Does this student already have a ChampionOne Student ID?",
          style: TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        if (selectedAdmissionCategory ==
            "New Student")
          RadioGroup<bool>(
            groupValue:
                hasPreviousChampionOneID,

            onChanged:
                (value) {
              if (value == null) {
                return;
              }

              setState(() {
                hasPreviousChampionOneID =
                    value;

                if (value ==
                    false) {
                  existingStudentIDController
                      .clear();

                  generatedStudentID =
                      generateStudentID();
                }
              });
            },

            child:
                const Column(
              children: [
                RadioListTile<
                    bool>(
                  value: true,

                  title:
                      Text(
                    "Yes — student already has a ChampionOne ID",
                  ),
                ),

                RadioListTile<
                    bool>(
                  value: false,

                  title:
                      Text(
                    "No — generate a new ChampionOne ID",
                  ),
                ),
              ],
            ),
          ),

        if (selectedAdmissionCategory ==
                "New Student" &&
            hasPreviousChampionOneID ==
                true)
          Padding(
            padding:
                const EdgeInsets
                    .only(
              top: 10,
            ),

            child:
                textField(
              controller:
                  existingStudentIDController,

              label:
                  "Previous ChampionOne Student ID",

              requiredField:
                  true,
            ),
          ),

        if (selectedAdmissionCategory ==
                "New Student" &&
            hasPreviousChampionOneID ==
                false)
          Padding(
            padding:
                const EdgeInsets
                    .only(
              top: 10,
            ),

            child:
                Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                12,
              ),

              decoration:
                  BoxDecoration(
                border:
                    Border.all(
                  color:
                      Colors.green,
                ),

                borderRadius:
                    BorderRadius.circular(
                  8,
                ),
              ),

              child:
                  Text(
                "New ChampionOne Student ID:\n"
                "$generatedStudentID",

                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Colors.green,
                ),
              ),
            ),
          ),

        if (selectedAdmissionCategory ==
                "Returning Student" ||
            selectedAdmissionCategory ==
                "Promotion / Internal Progression")
          Padding(
            padding:
                const EdgeInsets
                    .only(
              top: 10,
            ),

            child:
                textField(
              controller:
                  existingStudentIDController,

              label:
                  "Existing ChampionOne Student ID",

              requiredField:
                  true,
            ),
          ),

        const SizedBox(
          height: 15,
        ),
      ],
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
      appBar:
          AppBar(
        title:
            const Text(
          "Student Registration",
        ),

        backgroundColor:
            Colors.amber,

        foregroundColor:
            Colors.black,
      ),

      body: Form(
        key: formKey,

        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets
                  .all(
            20,
          ),

          child: Column(
            children: [
              // ==================================================
              // ADMISSION INFORMATION
              // ==================================================

              sectionTitle(
                "Admission Information",
              ),

              dropdownField(
                label:
                    "School Type",

                value:
                    selectedSchoolType,

                items:
                    schoolTypes,

                onChanged:
                    (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    selectedSchoolType =
                        value;
                  });
                },
              ),

              spacing(),

              dropdownField(
                label:
                    "Admission Category",

                value:
                    selectedAdmissionCategory,

                items:
                    admissionCategories,

                onChanged:
                    (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    selectedAdmissionCategory =
                        value;

                    if (value !=
                            "New Student" &&
                        value !=
                            "Returning Student" &&
                        value !=
                            "Promotion / Internal Progression") {
                      hasPreviousChampionOneID =
                          null;

                      existingStudentIDController
                          .clear();
                    }

                    if (value ==
                            "New Student" &&
                        generatedStudentID
                            .isEmpty) {
                      generatedStudentID =
                          generateStudentID();
                    }
                  });
                },
              ),

              spacing(),

              championOneIDSection(),

              // ==================================================
              // STUDENT IDENTITY
              // ==================================================

              sectionTitle(
                "Student Identity",
              ),

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Expanded(
                    child:
                        photoPreview(
                      title:
                          "Student Photo",

                      imageBytes:
                          studentPhotoBytes,

                      fileName:
                          studentPhotoName,

                      onChoose:
                          pickPhoto,
                    ),
                  ),

                  const SizedBox(
                    width: 15,
                  ),

                  Expanded(
                    child:
                        biometricPanel(),
                  ),
                ],
              ),

              // ==================================================
              // STUDENT INFORMATION
              // ==================================================

              const SizedBox(
                height: 25,
              ),

              sectionTitle(
                "Student Information",
              ),

              textField(
                controller:
                    fullNameController,

                label:
                    "Full Name",

                requiredField:
                    true,
              ),

              spacing(),

              textField(
                controller:
                    preferredNameController,

                label:
                    "Preferred Name",
              ),

              spacing(),

              dateField(
                label:
                    "Date of Birth",

                value:
                    dateOfBirth,

                onTap: () =>
                    pickDate(
                  dateOfBirthField:
                      true,
                ),
              ),

              spacing(),

              dropdownField(
                label:
                    "Gender",

                value:
                    selectedGender,

                items:
                    genders,

                onChanged:
                    (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    selectedGender =
                        value;
                  });
                },
              ),

              spacing(),

              textField(
                controller:
                    nationalityController,

                label:
                    "Nationality",

                requiredField:
                    true,
              ),

              spacing(),

              textField(
                controller:
                    addressController,

                label:
                    "Address",

                requiredField:
                    true,

                maxLines:
                    2,
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

              spacing(),

              dateField(
                label:
                    "Admission Date",

                value:
                    admissionDate,

                onTap: () =>
                    pickDate(
                  dateOfBirthField:
                      false,
                ),
              ),

              spacing(),

              dropdownField(
                label:
                    "Student Status",

                value:
                    selectedStudentStatus,

                items:
                    studentStatuses,

                onChanged:
                    (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    selectedStudentStatus =
                        value;
                  });
                },
              ),

              // ==================================================
              // ACADEMIC INFORMATION
              // ==================================================

              const SizedBox(
                height: 25,
              ),

              sectionTitle(
                "Academic Information",
              ),

              if (isEarlyChildhood) ...[
                textField(
                  controller:
                      classGradeController,

                  label:
                      "Level / Class",

                  requiredField:
                      true,
                ),

                spacing(),

                textField(
                  controller:
                      previousSchoolController,

                  label:
                      "Previous Daycare / Preschool",
                ),

                spacing(),

                textField(
                  controller:
                      pickupAuthorizationController,

                  label:
                      "Authorized Persons for Pickup",

                  maxLines:
                      2,
                ),

                spacing(),

                textField(
                  controller:
                      careInstructionsController,

                  label:
                      "Care / Special Instructions",

                  maxLines:
                      3,
                ),
              ],

              if (isPrimary ||
                  isPrimarySecondary ||
                  isSecondary) ...[
                textField(
                  controller:
                      classGradeController,

                  label:
                      isSecondary
                          ? "Grade / Form"
                          : "Grade / Class",

                  requiredField:
                      true,
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
                      "Previous Grade / Class",
                ),

                spacing(),

                textField(
                  controller:
                      previousAcademicYearController,

                  label:
                      "Previous Academic Year",
                ),
              ],

              if (isPrimarySecondary) ...[
                spacing(),

                textField(
                  controller:
                      previousPrimaryClassController,

                  label:
                      "Previous Primary Class",
                ),
              ],

              if (showHigherEducation) ...[
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

                  requiredField:
                      true,
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
                      previousSchoolController,

                  label:
                      "Previous Institution",
                ),
              ],

              if (isVocational) ...[
                textField(
                  controller:
                      programController,

                  label:
                      "Program / Trade",

                  requiredField:
                      true,
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
                      previousSchoolController,

                  label:
                      "Previous Institution",
                ),

                spacing(),

                textField(
                  controller:
                      practicalExperienceController,

                  label:
                      "Practical Experience",

                  maxLines:
                      3,
                ),
              ],

              // ==================================================
              // ADMISSION DOCUMENTS
              // ==================================================

              const SizedBox(
                height: 25,
              ),

              sectionTitle(
                "Admission Documents",
              ),

              if (showTranscript) ...[
                filePickerField(
                  label:
                      "Transcript / Academic Record",

                  fileName:
                      transcriptName,

                  onPressed:
                      () =>
                          pickDocument(
                    documentType:
                        "transcript",
                  ),
                ),

                spacing(),
              ],

              if (showRecommendation) ...[
                filePickerField(
                  label:
                      "Letter of Recommendation",

                  fileName:
                      recommendationName,

                  onPressed:
                      () =>
                          pickDocument(
                    documentType:
                        "recommendation",
                  ),
                ),

                spacing(),
              ],

              if (isPrimary ||
                  isPrimarySecondary ||
                  isSecondary ||
                  isCollege ||
                  isUniversity ||
                  isVocational)
                filePickerField(
                  label:
                      "Transfer Certificate",

                  fileName:
                      transferCertificateName,

                  onPressed:
                      () =>
                          pickDocument(
                    documentType:
                        "transfer",
                  ),
                ),

              spacing(),

              filePickerField(
                label:
                    "Other Admission Document",

                fileName:
                    otherDocumentName,

                onPressed:
                    () =>
                        pickDocument(
                  documentType:
                      "other",
                ),
              ),

              // ==================================================
              // PARENT / GUARDIAN
              // ==================================================

              const SizedBox(
                height: 25,
              ),

              sectionTitle(
                "Parent / Guardian Information",
              ),

              textField(
                controller:
                    parentGuardianNameController,

                label:
                    "Parent / Guardian Name",

                requiredField:
                    isEarlyChildhood ||
                    isPrimary ||
                    isSecondary ||
                    isPrimarySecondary,
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
                    "Parent / Guardian Phone",

                keyboardType:
                    TextInputType.phone,
              ),

              spacing(),

              textField(
                controller:
                    parentGuardianEmailController,

                label:
                    "Parent / Guardian Email",

                keyboardType:
                    TextInputType.emailAddress,
              ),

              spacing(),

              textField(
                controller:
                    parentGuardianAddressController,

                label:
                    "Parent / Guardian Address",

                maxLines:
                    2,
              ),

              spacing(),

              textField(
                controller:
                    parentGuardianOccupationController,

                label:
                    "Occupation",
              ),

              // ==================================================
              // PARENT / GUARDIAN PHOTO
              // ==================================================

              const SizedBox(
                height: 15,
              ),

              photoPreview(
                title:
                    "Parent / Guardian Photo",

                imageBytes:
                    parentPhotoBytes,

                fileName:
                    parentPhotoName,

                onChoose:
                    pickParentPhoto,
              ),

              // ==================================================
              // EMERGENCY CONTACT
              // ==================================================

              spacing(),

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
              // REVIEW APPLICATION
              // ==================================================

              SizedBox(
                width:
                    double.infinity,

                height:
                    58,

                child:
                    ElevatedButton.icon(
                  onPressed:
                      isSaving
                          ? null
                          : reviewApplication,

                  icon:
                      const Icon(
                    Icons.preview,
                  ),

                  label:
                      const Text(
                    "REVIEW APPLICATION",

                    style:
                        TextStyle(
                      fontSize: 17,
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
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// REVIEW SCREEN
// ==================================================================

class StudentApplicationReviewScreen
    extends StatelessWidget {
  final Map<String, dynamic> data;

  const StudentApplicationReviewScreen({
    super.key,
    required this.data,
  });

  Widget reviewRow(
    String label,
    String value,
  ) {
    if (value.trim().isEmpty) {
      return const SizedBox
          .shrink();
    }

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [
          SizedBox(
            width: 155,

            child:
                Text(
              "$label:",

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child:
                Text(value),
          ),
        ],
      ),
    );
  }

  Widget section(
    String title,
    List<Widget> children,
  ) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 15,
      ),

      child:
          Padding(
        padding:
            const EdgeInsets.all(
          15,
        ),

        child:
            Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [
            Text(
              title,

              style:
                  const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar:
          AppBar(
        title:
            const Text(
          "Review Student Application",
        ),

        backgroundColor:
            Colors.amber,

        foregroundColor:
            Colors.black,
      ),

      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child:
            Column(
          children: [
            const Text(
              "Please review all information before saving.",

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // ADMISSION
            // ==================================================

            section(
              "Admission Information",
              [
                reviewRow(
                  "School Type",
                  data["schoolType"] ??
                      "",
                ),

                reviewRow(
                  "Admission Category",
                  data[
                          "admissionCategory"] ??
                      "",
                ),

                reviewRow(
                  "Student ID",
                  data["studentID"] ??
                      "",
                ),

                reviewRow(
                  "Academic Year",
                  data[
                          "academicYear"] ??
                      "",
                ),

                reviewRow(
                  "Admission Date",
                  data[
                          "admissionDate"] ??
                      "",
                ),

                reviewRow(
                  "Status",
                  data[
                          "studentStatus"] ??
                      "",
                ),

                reviewRow(
                  "Biometric Status",
                  data[
                          "biometricStatus"] ??
                      "",
                ),
              ],
            ),

            // ==================================================
            // STUDENT
            // ==================================================

            section(
              "Student Information",
              [
                reviewRow(
                  "Full Name",
                  data["fullName"] ??
                      "",
                ),

                reviewRow(
                  "Preferred Name",
                  data[
                          "preferredName"] ??
                      "",
                ),

                reviewRow(
                  "Date of Birth",
                  data[
                          "dateOfBirth"] ??
                      "",
                ),

                reviewRow(
                  "Gender",
                  data["gender"] ??
                      "",
                ),

                reviewRow(
                  "Nationality",
                  data[
                          "nationality"] ??
                      "",
                ),

                reviewRow(
                  "Address",
                  data["address"] ??
                      "",
                ),

                reviewRow(
                  "Phone",
                  data["phone"] ??
                      "",
                ),
              ],
            ),

            // ==================================================
            // ACADEMIC
            // ==================================================

            section(
              "Academic Information",
              [
                reviewRow(
                  "Class / Grade",
                  data[
                          "classGrade"] ??
                      "",
                ),

                reviewRow(
                  "Previous School",
                  data[
                          "previousSchool"] ??
                      "",
                ),

                reviewRow(
                  "Previous Grade",
                  data[
                          "previousGrade"] ??
                      "",
                ),

                reviewRow(
                  "Previous Academic Year",
                  data[
                          "previousAcademicYear"] ??
                      "",
                ),

                reviewRow(
                  "Faculty",
                  data["faculty"] ??
                      "",
                ),

                reviewRow(
                  "Department",
                  data[
                          "department"] ??
                      "",
                ),

                reviewRow(
                  "Program",
                  data["program"] ??
                      "",
                ),

                reviewRow(
                  "Major",
                  data["major"] ??
                      "",
                ),

                reviewRow(
                  "Training Level",
                  data[
                          "trainingLevel"] ??
                      "",
                ),

                reviewRow(
                  "Practical Experience",
                  data[
                          "practicalExperience"] ??
                      "",
                ),

                reviewRow(
                  "Previous Primary Class",
                  data[
                          "previousPrimaryClass"] ??
                      "",
                ),
              ],
            ),

            // ==================================================
            // PARENT / GUARDIAN
            // ==================================================

            section(
              "Parent / Guardian",
              [
                reviewRow(
                  "Name",
                  data[
                          "parentGuardianName"] ??
                      "",
                ),

                reviewRow(
                  "Relationship",
                  data[
                          "parentGuardianRelationship"] ??
                      "",
                ),

                reviewRow(
                  "Phone",
                  data[
                          "parentGuardianPhone"] ??
                      "",
                ),

                reviewRow(
                  "Email",
                  data[
                          "parentGuardianEmail"] ??
                      "",
                ),

                reviewRow(
                  "Address",
                  data[
                          "parentGuardianAddress"] ??
                      "",
                ),

                reviewRow(
                  "Occupation",
                  data[
                          "parentGuardianOccupation"] ??
                      "",
                ),

                reviewRow(
                  "Parent / Guardian Photo",
                  data[
                          "parentPhoto"] ??
                      "",
                ),

                reviewRow(
                  "Emergency Contact",
                  data[
                          "emergencyContactName"] ??
                      "",
                ),

                reviewRow(
                  "Emergency Phone",
                  data[
                          "emergencyContactPhone"] ??
                      "",
                ),
              ],
            ),

            // ==================================================
            // DOCUMENTS
            // ==================================================

            section(
              "Documents",
              [
                reviewRow(
                  "Student Photo",
                  data[
                          "studentPhoto"] ??
                      "",
                ),

                reviewRow(
                  "Transcript",
                  data[
                          "transcript"] ??
                      "",
                ),

                reviewRow(
                  "Recommendation",
                  data[
                          "recommendation"] ??
                      "",
                ),

                reviewRow(
                  "Transfer Certificate",
                  data[
                          "transferCertificate"] ??
                      "",
                ),

                reviewRow(
                  "Other Document",
                  data[
                          "otherDocument"] ??
                      "",
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            // ==================================================
            // ACTIONS
            // ==================================================

            Row(
              children: [
                Expanded(
                  child:
                      OutlinedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pop(false);
                    },

                    style:
                        OutlinedButton
                            .styleFrom(
                      minimumSize:
                          const Size(
                        double.infinity,
                        55,
                      ),
                    ),

                    child:
                        const Text(
                      "BACK TO EDIT",
                    ),
                  ),
                ),

                const SizedBox(
                  width: 15,
                ),

                Expanded(
                  child:
                      ElevatedButton
                          .icon(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pop(true);
                    },

                    icon:
                        const Icon(
                      Icons.check_circle,
                    ),

                    label:
                        const Text(
                      "CONFIRM & SAVE",
                    ),

                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          Colors.green,

                      foregroundColor:
                          Colors.white,

                      minimumSize:
                          const Size(
                        double.infinity,
                        55,
                      ),
                    ),
                  ),
                ),
              ],
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