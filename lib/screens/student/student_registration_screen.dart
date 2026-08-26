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

  final previousSchoolController = TextEditingController();
  final previousGradeController = TextEditingController();
  final previousAcademicYearController =
      TextEditingController();

  final facultyController = TextEditingController();
  final departmentController = TextEditingController();
  final programController = TextEditingController();
  final majorController = TextEditingController();
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
  // DROPDOWN / DATE VALUES
  // ============================================================

  String selectedSchoolType =
      "Primary School";

  String selectedAdmissionCategory =
      "New Student";

  String selectedGender = "Male";

  String selectedStudentStatus =
      "Pending";

  String academicYear = "2026/2027";

  String dateOfBirth = "";

  String admissionDate = "";

  // ============================================================
  // FILES
  // ============================================================

  Uint8List? studentPhotoBytes;
  String studentPhotoName = "";

  Uint8List? transcriptBytes;
  String transcriptName = "";

  Uint8List? recommendationBytes;
  String recommendationName = "";

  Uint8List? transferCertificateBytes;
  String transferCertificateName = "";

  Uint8List? otherDocumentBytes;
  String otherDocumentName = "";

  bool isSaving = false;

bool? hasPreviousChampionOneID;

String generatedStudentID = "";
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
    previousAcademicYearController
        .dispose();

    facultyController.dispose();
    departmentController.dispose();
    programController.dispose();
    majorController.dispose();
    trainingLevelController.dispose();
    practicalExperienceController
        .dispose();

    existingStudentIDController.dispose();
    previousPrimaryClassController.dispose();

    pickupAuthorizationController.dispose();
    careInstructionsController.dispose();

    parentGuardianNameController.dispose();
    parentGuardianRelationshipController
        .dispose();
    parentGuardianPhoneController.dispose();
    parentGuardianEmailController.dispose();
    parentGuardianAddressController.dispose();
    parentGuardianOccupationController
        .dispose();

    emergencyContactNameController.dispose();
    emergencyContactPhoneController
        .dispose();

    super.dispose();
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> pickDate({
    required bool dateOfBirthField,
  }) async {
    final selected =
        await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate:
          DateTime.now().add(
        const Duration(days: 3650),
      ),
      initialDate: DateTime.now(),
    );

    if (selected == null) {
      return;
    }

    final formatted =
        "${selected.year.toString().padLeft(4, '0')}-"
        "${selected.month.toString().padLeft(2, '0')}-"
        "${selected.day.toString().padLeft(2, '0')}";

    setState(() {
      if (dateOfBirthField) {
        dateOfBirth = formatted;
      } else {
        admissionDate = formatted;
      }
    });
  }

  // ============================================================
  // FILE PICKER
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
      return;
    }

    setState(() {
      studentPhotoBytes = file.bytes;
      studentPhotoName = file.name;
    });
  }

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
      return;
    }

    setState(() {
      if (documentType == "transcript") {
        transcriptBytes = file.bytes;
        transcriptName = file.name;
      } else if (documentType ==
          "recommendation") {
        recommendationBytes = file.bytes;
        recommendationName = file.name;
      } else if (documentType ==
          "transfer") {
        transferCertificateBytes = file.bytes;
        transferCertificateName = file.name;
      } else {
        otherDocumentBytes = file.bytes;
        otherDocumentName = file.name;
      }
    });
  }

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
      selectedSchoolType == "College";

  bool get isUniversity =>
      selectedSchoolType == "University";

  bool get isVocational =>
      selectedSchoolType ==
      "Vocational / Technical Training Institute";

  bool get showAcademicHistory =>
      isPrimary ||
      isPrimarySecondary ||
      isSecondary ||
      isCollege ||
      isUniversity ||
      isVocational;

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
  // FORM VALIDATION
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

    if (isPrimarySecondary &&
        existingStudentIDController
            .text
            .trim()
            .isEmpty) {
      showMessage(
        "Please enter the existing Student ID "
        "for internal progression, or enter "
        "the appropriate admission information.",
      );
      return false;
    }

    return true;
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
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
        DateTime.now().millisecondsSinceEpoch;

    return "STU-$timestamp";
  }

  String resolveStudentID() {
  // Existing ChampionOne ID
  if (hasPreviousChampionOneID == true) {
    final previousID =
        existingStudentIDController.text.trim();

    if (previousID.isNotEmpty) {
      return previousID;
    }
  }

  // Generate once and keep the same ID
  // through Preview and Save.
  if (generatedStudentID.isEmpty) {
    generatedStudentID =
        generateStudentID();
  }

  return generatedStudentID;
}

  // ============================================================
  // REVIEW
  // ============================================================

  Future<void> reviewApplication() async {
    if (!validateApplication()) {
      return;
    }

    final draft =
        _buildReviewData();

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

    if (confirmed == true) {
      await saveStudent();
    }
  }

  Map<String, dynamic> _buildReviewData() {
    return {
      "schoolType": selectedSchoolType,
      "admissionCategory":
          selectedAdmissionCategory,
      "studentID": generateStudentID(),
      "fullName":
          fullNameController.text.trim(),
      "preferredName":
          preferredNameController.text.trim(),
      "dateOfBirth": dateOfBirth,
      "gender": selectedGender,
      "nationality":
          nationalityController.text.trim(),
      "address":
          addressController.text.trim(),
      "phone":
          phoneController.text.trim(),
      "academicYear": academicYear,
      "admissionDate": admissionDate,
      "studentStatus": selectedStudentStatus,
      "classGrade":
          classGradeController.text.trim(),
      "previousSchool":
          previousSchoolController.text.trim(),
      "previousGrade":
          previousGradeController.text.trim(),
      "previousAcademicYear":
          previousAcademicYearController.text
              .trim(),
      "faculty":
          facultyController.text.trim(),
      "department":
          departmentController.text.trim(),
      "program":
          programController.text.trim(),
      "major":
          majorController.text.trim(),
      "trainingLevel":
          trainingLevelController.text.trim(),
      "practicalExperience":
          practicalExperienceController.text
              .trim(),
      "parentGuardianName":
          parentGuardianNameController.text
              .trim(),
      "parentGuardianRelationship":
          parentGuardianRelationshipController
              .text
              .trim(),
      "parentGuardianPhone":
          parentGuardianPhoneController.text
              .trim(),
      "parentGuardianEmail":
          parentGuardianEmailController.text
              .trim(),
      "parentGuardianAddress":
          parentGuardianAddressController.text
              .trim(),
      "parentGuardianOccupation":
          parentGuardianOccupationController
              .text
              .trim(),
      "emergencyContactName":
          emergencyContactNameController.text
              .trim(),
      "emergencyContactPhone":
          emergencyContactPhoneController.text
              .trim(),
      "existingStudentID":
          existingStudentIDController.text
              .trim(),
      "previousPrimaryClass":
          previousPrimaryClassController.text
              .trim(),
      "pickupAuthorization":
          pickupAuthorizationController.text
              .trim(),
      "careInstructions":
          careInstructionsController.text.trim(),
      "studentPhoto": studentPhotoName,
      "transcript": transcriptName,
      "recommendation": recommendationName,
      "transferCertificate":
          transferCertificateName,
      "otherDocument":
          otherDocumentName,
    };
  }

  // ============================================================
  // SAVE STUDENT
  // ============================================================

  Future<void> saveStudent() async {
    if (isSaving) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final studentID =
          generateStudentID();

      String studentPhotoPath = "";
      String transcriptPath = "";
      String recommendationPath = "";
      String transferPath = "";
      String otherDocumentPath = "";

      // --------------------------------------------------------
      // PHOTO
      // --------------------------------------------------------

      if (studentPhotoBytes != null) {
        studentPhotoPath =
            await FileStorage.saveStaffPhoto(
          studentPhotoBytes!,
          fileName: studentPhotoName,
        );
      }

      // --------------------------------------------------------
      // DOCUMENTS
      // --------------------------------------------------------

      if (transcriptBytes != null) {
        transcriptPath =
            await FileStorage.saveStaffDocument(
          transcriptBytes!,
          fileName: transcriptName,
        );
      }

      if (recommendationBytes != null) {
        recommendationPath =
            await FileStorage.saveStaffDocument(
          recommendationBytes!,
          fileName: recommendationName,
        );
      }

      if (transferCertificateBytes != null) {
        transferPath =
            await FileStorage.saveStaffDocument(
          transferCertificateBytes!,
          fileName:
              transferCertificateName,
        );
      }

      if (otherDocumentBytes != null) {
        otherDocumentPath =
            await FileStorage.saveStaffDocument(
          otherDocumentBytes!,
          fileName: otherDocumentName,
        );
      }

      // --------------------------------------------------------
      // STUDENT OBJECT
      // --------------------------------------------------------

      final student = StudentModel(
        studentID: studentID,

        fullName:
            fullNameController.text.trim(),

        preferredName:
            preferredNameController.text.trim(),

        dateOfBirth:
            dateOfBirth,

        gender:
            selectedGender,

        nationality:
            nationalityController.text.trim(),

        address:
            addressController.text.trim(),

        phone:
            phoneController.text.trim(),

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
            classGradeController.text.trim(),

        previousSchool:
            previousSchoolController.text.trim(),

        previousGrade:
            previousGradeController.text.trim(),

        previousAcademicYear:
            previousAcademicYearController.text
                .trim(),

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
            practicalExperienceController.text
                .trim(),

        parentGuardianName:
            parentGuardianNameController.text
                .trim(),

        parentGuardianRelationship:
            parentGuardianRelationshipController
                .text
                .trim(),

        parentGuardianPhone:
            parentGuardianPhoneController.text
                .trim(),

        parentGuardianEmail:
            parentGuardianEmailController.text
                .trim(),

        parentGuardianAddress:
            parentGuardianAddressController.text
                .trim(),

        parentGuardianOccupation:
            parentGuardianOccupationController
                .text
                .trim(),

        emergencyContactName:
            emergencyContactNameController.text
                .trim(),

        emergencyContactPhone:
            emergencyContactPhoneController.text
                .trim(),

        studentPhoto:
            studentPhotoPath,

        transcriptDocument:
            transcriptPath,

        recommendationDocument:
            recommendationPath,

        transferCertificate:
            transferPath,

        otherDocuments:
            otherDocumentPath,
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

      ScaffoldMessenger.of(context).showSnackBar(
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

      ScaffoldMessenger.of(context).showSnackBar(
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
  // FIELD HELPERS
  // ============================================================

  Widget textField({
    required TextEditingController controller,
    required String label,
    bool requiredField = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
      decoration: InputDecoration(
        labelText: label,
        border:
            const OutlineInputBorder(),
      ),
    );
  }

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

  Widget spacing() {
    return const SizedBox(
      height: 15,
    );
  }

  Widget dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?>
        onChanged,
  }) {
    return DropdownButtonFormField<
        String>(
      initialValue: value,
      decoration:
          InputDecoration(
        labelText: label,
        border:
            const OutlineInputBorder(),
      ),
      items: items
          .map(
            (item) =>
                DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget dateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      readOnly: true,
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
        labelText: label,
        border:
            const OutlineInputBorder(),
        suffixIcon:
            const Icon(
          Icons.calendar_today,
        ),
      ),
    );
  }

  Widget filePickerField({
    required String label,
    required String fileName,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
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
          onPressed: onPressed,
          icon: const Icon(
            Icons.attach_file,
          ),
          label: Text(
            fileName.isEmpty
                ? "Choose File"
                : fileName,
          ),
        ),
      ],
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
              const EdgeInsets.all(
            20,
          ),

          child: Column(
            children: [
              // ==================================================
              // ADMISSION TYPE
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
                  });
                },
              ),

              spacing(),

              // ==================================================
              // COMMON STUDENT INFORMATION
              // ==================================================

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

              spacing(),

              filePickerField(
                label:
                    "Student Photo",
                fileName:
                    studentPhotoName,
                onPressed:
                    pickPhoto,
              ),

              // ==================================================
              // SCHOOL SPECIFIC
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
                  isSecondary ||
                  isPrimarySecondary) ...[
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
                      existingStudentIDController,
                  label:
                      "Existing ChampionOne Student ID",
                  requiredField:
                      true,
                ),

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
              // DOCUMENTS
              // ==================================================

              if (showTranscript ||
                  showRecommendation ||
                  isPrimary ||
                  isPrimarySecondary) ...[
                const SizedBox(
                  height: 25,
                ),

                sectionTitle(
                  "Admission Documents",
                ),
              ],

              if (showTranscript) ...[
                filePickerField(
                  label:
                      "Transcript / Academic Record",
                  fileName:
                      transcriptName,
                  onPressed: () =>
                      pickDocument(
                    documentType:
                        "transcript",
                  ),
                ),

                spacing(),
              ],

              if (showRecommendation)
                filePickerField(
                  label:
                      "Letter of Recommendation",
                  fileName:
                      recommendationName,
                  onPressed: () =>
                      pickDocument(
                    documentType:
                        "recommendation",
                  ),
                ),

              if (showRecommendation)
                spacing(),

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
                  onPressed: () =>
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
                onPressed: () =>
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
                    isSecondary,
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
              // REVIEW BUTTON
              // ==================================================

              SizedBox(
                width:
                    double.infinity,
                height: 58,
                child:
                    ElevatedButton.icon(
                  onPressed:
                      isSaving
                          ? null
                          : reviewApplication,
                  icon: const Icon(
                    Icons.preview,
                  ),
                  label: const Text(
                    "REVIEW APPLICATION",
                    style:
                        TextStyle(
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
      return const SizedBox.shrink();
    }

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 155,
            child: Text(
              "$label:",
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
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
      child: Padding(
        padding:
            const EdgeInsets.all(15),
        child: Column(
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Review Student Application",
        ),
        backgroundColor:
            Colors.amber,
        foregroundColor:
            Colors.black,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Please review all information before saving.",
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            section(
              "Admission Information",
              [
                reviewRow(
                  "School Type",
                  data["schoolType"] ?? "",
                ),
                reviewRow(
                  "Admission Category",
                  data[
                          "admissionCategory"] ??
                      "",
                ),
                reviewRow(
                  "Student ID",
                  data["studentID"] ?? "",
                ),
                reviewRow(
                  "Academic Year",
                  data["academicYear"] ?? "",
                ),
                reviewRow(
                  "Admission Date",
                  data["admissionDate"] ?? "",
                ),
                reviewRow(
                  "Status",
                  data["studentStatus"] ?? "",
                ),
              ],
            ),

            section(
              "Student Information",
              [
                reviewRow(
                  "Full Name",
                  data["fullName"] ?? "",
                ),
                reviewRow(
                  "Preferred Name",
                  data["preferredName"] ?? "",
                ),
                reviewRow(
                  "Date of Birth",
                  data["dateOfBirth"] ?? "",
                ),
                reviewRow(
                  "Gender",
                  data["gender"] ?? "",
                ),
                reviewRow(
                  "Nationality",
                  data["nationality"] ?? "",
                ),
                reviewRow(
                  "Address",
                  data["address"] ?? "",
                ),
                reviewRow(
                  "Phone",
                  data["phone"] ?? "",
                ),
              ],
            ),

            section(
              "Academic Information",
              [
                reviewRow(
                  "Class / Grade",
                  data["classGrade"] ?? "",
                ),
                reviewRow(
                  "Previous School",
                  data["previousSchool"] ?? "",
                ),
                reviewRow(
                  "Previous Grade",
                  data["previousGrade"] ?? "",
                ),
                reviewRow(
                  "Faculty",
                  data["faculty"] ?? "",
                ),
                reviewRow(
                  "Department",
                  data["department"] ?? "",
                ),
                reviewRow(
                  "Program",
                  data["program"] ?? "",
                ),
                reviewRow(
                  "Major",
                  data["major"] ?? "",
                ),
                reviewRow(
                  "Training Level",
                  data["trainingLevel"] ?? "",
                ),
                reviewRow(
                  "Practical Experience",
                  data[
                          "practicalExperience"] ??
                      "",
                ),
              ],
            ),

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

            section(
              "Documents",
              [
                reviewRow(
                  "Student Photo",
                  data["studentPhoto"] ?? "",
                ),
                reviewRow(
                  "Transcript",
                  data["transcript"] ?? "",
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
                        OutlinedButton.styleFrom(
                      minimumSize:
                          const Size(
                        double.infinity,
                        55,
                      ),
                    ),
                    child: const Text(
                      "BACK TO EDIT",
                    ),
                  ),
                ),

                const SizedBox(
                  width: 15,
                ),

                Expanded(
                  child:
                      ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pop(true);
                    },
                    icon: const Icon(
                      Icons.check_circle,
                    ),
                    label: const Text(
                      "CONFIRM & SAVE",
                    ),
                    style:
                        ElevatedButton.styleFrom(
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