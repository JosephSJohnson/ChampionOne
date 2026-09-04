import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/student_data.dart';
import '../../database/database_helper.dart';
import '../../models/student_model.dart';
import '../../utils/file_storage.dart';

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
  // PARENT / GUARDIAN PHOTO
  // ============================================================

  Uint8List? parentPhotoBytes;
  String parentPhotoName = "";

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
      text: widget.student.parentGuardianRelationship,
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

    selectedGender =
        widget.student.gender;

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
  // PICK PARENT / GUARDIAN PHOTO
  // ============================================================

  Future<void> pickParentPhoto() async {
    try {
      final result =
          await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result == null ||
          result.files.isEmpty) {
        return;
      }

      final file = result.files.first;

      if (file.bytes == null) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Unable to read the selected photo.",
            ),
          ),
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
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Failed to select parent photo: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> saveChanges() async {
    String newParentPhotoPath = "";

    try {
      // ----------------------------------------------------------
      // SAVE NEW PARENT PHOTO ONLY WHEN ONE WAS SELECTED
      // ----------------------------------------------------------

      if (parentPhotoBytes != null) {
        newParentPhotoPath =
            await FileStorage.saveStaffPhoto(
          parentPhotoBytes!,
          fileName: parentPhotoName,
        );
      } else {
        // Preserve the existing stored parent photo.
        newParentPhotoPath =
            widget.student.parentPhoto;
      }

      // ----------------------------------------------------------
      // UPDATED STUDENT
      // ----------------------------------------------------------

      final updatedStudent = StudentModel(
        id: widget.student.id,

        studentID:
            widget.student.studentID,

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

        // --------------------------------------------------------
        // PARENT PHOTO
        // --------------------------------------------------------

        parentPhoto:
            newParentPhotoPath,

        // --------------------------------------------------------
        // EMERGENCY
        // --------------------------------------------------------

        emergencyContactName:
            emergencyContactNameController
                .text
                .trim(),

        emergencyContactPhone:
            emergencyContactPhoneController
                .text
                .trim(),

        // --------------------------------------------------------
        // KEEP EXISTING STUDENT FILES
        // --------------------------------------------------------

        studentPhoto:
            widget.student.studentPhoto,

        transcriptDocument:
            widget.student.transcriptDocument,

        recommendationDocument:
            widget.student
                .recommendationDocument,

        transferCertificate:
            widget.student
                .transferCertificate,

        otherDocuments:
            widget.student.otherDocuments,

        // --------------------------------------------------------
        // KEEP EXISTING BIOMETRIC INFORMATION
        // --------------------------------------------------------

        biometricStatus:
            widget.student.biometricStatus,

        biometricReference:
            widget.student.biometricReference,

        biometricProvider:
            widget.student.biometricProvider,

        biometricEnrolledDate:
            widget.student.biometricEnrolledDate,
      );

      // ----------------------------------------------------------
      // DATABASE
      // ----------------------------------------------------------

      await DatabaseHelper.instance
          .updateStudent(
        updatedStudent.toMap(),
      );

      // ----------------------------------------------------------
      // DELETE OLD PARENT PHOTO AFTER SUCCESSFUL UPDATE
      // ----------------------------------------------------------

      if (parentPhotoBytes != null &&
          widget.student.parentPhoto.isNotEmpty &&
          widget.student.parentPhoto !=
              newParentPhotoPath) {
        await FileStorage.deleteFile(
          widget.student.parentPhoto,
        );
      }

      // ----------------------------------------------------------
      // MEMORY
      // ----------------------------------------------------------

      StudentData.updateStudent(
        updatedStudent,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(
        updatedStudent,
      );
    } catch (e) {
      // ----------------------------------------------------------
      // CLEAN UP NEW PHOTO IF DATABASE UPDATE FAILED
      // ----------------------------------------------------------

      if (newParentPhotoPath.isNotEmpty &&
          parentPhotoBytes != null &&
          newParentPhotoPath !=
              widget.student.parentPhoto) {
        try {
          await FileStorage.deleteFile(
            newParentPhotoPath,
          );
        } catch (_) {
          // Ignore cleanup errors.
        }
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
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
  // PARENT PHOTO CARD
  // ============================================================

  Widget parentPhotoCard() {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          15,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Parent / Guardian Photo",
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Center(
              child: Container(
                width: 150,
                height: 180,
                decoration:
                    BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                  color: Colors.grey.shade100,
                ),
                child:
                    parentPhotoBytes != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                            child:
                                Image.memory(
                              parentPhotoBytes!,
                              width:
                                  double.infinity,
                              height:
                                  double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : widget.student
                                .parentPhoto
                                .isEmpty
                            ? const Center(
                                child:
                                    Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  children: [
                                    Icon(
                                      Icons
                                          .person,
                                      size: 60,
                                      color:
                                          Colors.grey,
                                    ),
                                    SizedBox(
                                      height:
                                          8,
                                    ),
                                    Text(
                                      "No photo",
                                      style:
                                          TextStyle(
                                        color:
                                            Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const Center(
                                child:
                                    Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  children: [
                                    Icon(
                                      Icons
                                          .photo,
                                      size: 50,
                                      color:
                                          Colors.blue,
                                    ),
                                    SizedBox(
                                      height:
                                          8,
                                    ),
                                    Text(
                                      "Existing photo",
                                      style:
                                          TextStyle(
                                        color:
                                            Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            if (parentPhotoName.isNotEmpty)
              Text(
                "New photo: $parentPhotoName",
                style: const TextStyle(
                  color: Colors.green,
                ),
              )
            else if (widget.student
                .parentPhoto.isNotEmpty)
              Text(
                "A parent / guardian photo is already stored.",
                style: TextStyle(
                  color:
                      Colors.grey.shade700,
                ),
              )
            else
              const Text(
                "No parent / guardian photo uploaded.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

            const SizedBox(
              height: 12,
            ),

            SizedBox(
              width: double.infinity,
              child:
                  ElevatedButton.icon(
                onPressed:
                    pickParentPhoto,
                icon: const Icon(
                  Icons.photo_camera,
                ),
                label: Text(
                  widget.student
                          .parentPhoto
                          .isNotEmpty
                      ? "CHANGE PARENT PHOTO"
                      : "ADD PARENT PHOTO",
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue,
                  foregroundColor:
                      Colors.white,
                ),
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
        title: const Text(
          "Edit Student",
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

            parentPhotoCard(),

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
              child:
                  ElevatedButton.icon(
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