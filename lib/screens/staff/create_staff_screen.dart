import 'dart:typed_data';
import 'dart:io' show File;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/staff_data.dart';
import '../../database/database_helper.dart';
import '../../models/staff_model.dart';
import '../../utils/file_storage.dart';
import '../../utils/id_generator.dart';

class CreateStaffScreen extends StatefulWidget {
  const CreateStaffScreen({super.key});

  @override
  State<CreateStaffScreen> createState() =>
      _CreateStaffScreenState();
}

class _CreateStaffScreenState
    extends State<CreateStaffScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final fullNameController = TextEditingController();
  final nationalityController = TextEditingController();
  final addressController = TextEditingController();

  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =
      TextEditingController();

  final otherQualificationController =
      TextEditingController();

  // ============================================================
  // PHOTO & DOCUMENT
  // ============================================================

  XFile? selectedImage;
  Uint8List? selectedImageBytes;

  PlatformFile? qualificationFile;

  // ============================================================
  // STAFF INFORMATION
  // ============================================================

  String staffID = "";

  String gender = "Male";

  String selectedRole = "Teacher";

  String highestQualification =
      "High School Diploma";

  String accountStatus = "Pending";

  DateTime? dateOfBirth;

  // ============================================================
  // DROPDOWN LISTS
  // ============================================================

  final List<String> genders = [
    "Male",
    "Female",
  ];

  final List<String> qualifications = [
    "High School Diploma",
    "Certificate",
    "Diploma",
    "Associate Degree",
    "Bachelor's Degree",
    "Master's Degree",
    "Doctorate (PhD)",
    "Professional Qualification",
    "Other",
  ];

  final List<String> roles = [
    "Principal",
    "Vice Principal Academic Affairs",
    "Vice Principal Student Affairs",
    "Finance Officer",
    "Secretary",
    "Teacher",
    "Class Teacher",
    "Librarian",
    "Other Staff",
  ];

  final List<String> accountStatuses = [
    "Active",
    "Pending",
    "Disabled",
  ];

  // ============================================================
  // PICK DATE OF BIRTH
  // ============================================================

  Future<void> pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      dateOfBirth = picked;
    });
  }

  // ============================================================
  // PICK STAFF PHOTO
  // ============================================================

  Future<void> pickStaffImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();

    if (!mounted) {
      return;
    }

    setState(() {
      selectedImage = image;
      selectedImageBytes = bytes;
    });
  }

  // ============================================================
  // PICK QUALIFICATION DOCUMENT
  // ============================================================

  Future<void> pickQualification() async {
    final result =
        await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        "pdf",
        "jpg",
        "jpeg",
        "png",
        "doc",
        "docx",
      ],
    );

    if (result == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      qualificationFile = result.files.first;
    });
  }

  // ============================================================
  // CREATE STAFF ACCOUNT
  // ============================================================

  Future<void> createAccount() async {
    // -------------------------
    // VALIDATION
    // -------------------------

    if (fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please enter the staff full name."),
        ),
      );
      return;
    }

    if (usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a username."),
        ),
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a password."),
        ),
      );
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please confirm the password."),
        ),
      );
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match."),
        ),
      );
      return;
    }

    try {
      // -------------------------
      // GENERATE STAFF ID
      // -------------------------

      final generatedStaffID =
          IDGenerator.generateStaffID();

      staffID = generatedStaffID;

      // -------------------------
      // SAVE STAFF PHOTO
      // -------------------------

      String savedProfileImage = "";

      if (selectedImage != null) {
  final imageBytes =
      await selectedImage!.readAsBytes();

  savedProfileImage =
      await FileStorage.saveStaffPhoto(
    imageBytes,
    fileName: selectedImage!.name,
  );
}

      // -------------------------
      // SAVE QUALIFICATION DOCUMENT
      // -------------------------

      String qualificationDocumentPath = "";

      if (qualificationFile != null) {
  Uint8List? documentBytes;

  if (qualificationFile!.bytes != null) {
    documentBytes = qualificationFile!.bytes;
  } else if (qualificationFile!.path != null) {
    documentBytes =
        await File(qualificationFile!.path!)
            .readAsBytes();
  }

  if (documentBytes != null) {
    qualificationDocumentPath =
        await FileStorage.saveStaffDocument(
      documentBytes,
      fileName: qualificationFile!.name,
    );
  }
}

      // -------------------------
      // CREATE STAFF MODEL
      // -------------------------

      final StaffModel staff = StaffModel(
        staffID: generatedStaffID,

        profileImage: savedProfileImage,

        qualificationDocument:
            qualificationDocumentPath,

        fullName:
            fullNameController.text.trim(),

        dateOfBirth: dateOfBirth == null
            ? ""
            : "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}",

        gender: gender,

        nationality:
            nationalityController.text.trim(),

        address:
            addressController.text.trim(),

        qualification:
            highestQualification,

        otherQualification:
            otherQualificationController
                .text
                .trim(),

        phone:
            phoneController.text.trim(),

        email:
            emailController.text.trim(),

        role: selectedRole,

        username:
            usernameController.text.trim(),

        password:
            passwordController.text,

        accountStatus:
            accountStatus,

        createdDate: DateTime.now(),
      );

      // -------------------------
      // SAVE TO DATABASE
      // -------------------------

      await DatabaseHelper.instance.insertStaff(
        staff.toMap(),
      );

      // -------------------------
      // UPDATE STAFF DATA
      // -------------------------

      StaffData.addStaff(staff);

      if (!mounted) {
        return;
      }

      // -------------------------
      // SUCCESS MESSAGE
      // -------------------------

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Staff account created successfully.\n"
            "Staff ID: $generatedStaffID",
          ),
        ),
      );

      // -------------------------
      // RESET FORM
      // -------------------------

      setState(() {
        fullNameController.clear();
        nationalityController.clear();
        addressController.clear();

        phoneController.clear();
        emailController.clear();

        usernameController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        otherQualificationController.clear();

        selectedImage = null;
        selectedImageBytes = null;

        qualificationFile = null;

        gender = "Male";

        selectedRole = "Teacher";

        highestQualification =
            "High School Diploma";

        accountStatus = "Pending";

        dateOfBirth = null;

        staffID = "";
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Failed to create staff account:\n$e",
          ),
        ),
      );

      debugPrint(
        "CREATE STAFF ACCOUNT ERROR: $e",
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    fullNameController.dispose();
    nationalityController.dispose();
    addressController.dispose();

    phoneController.dispose();
    emailController.dispose();

    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    otherQualificationController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Create Staff Account"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // ==================================================
            // STAFF INFORMATION
            // ==================================================

            const Text(
              "Staff Information",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // STAFF PHOTO
            // ==================================================

            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,

                    backgroundImage:
                        selectedImageBytes != null
                            ? MemoryImage(
                                selectedImageBytes!,
                              )
                            : null,

                    child:
                        selectedImageBytes == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                              )
                            : null,
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton.icon(
                    onPressed: pickStaffImage,
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                    label: const Text(
                      "SELECT STAFF PHOTO",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // DATE OF BIRTH
            // ==================================================

            ListTile(
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8),
                side: const BorderSide(
                  color: Colors.grey,
                ),
              ),

              title: Text(
                dateOfBirth == null
                    ? "Select Date of Birth"
                    : "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}",
              ),

              trailing: const Icon(
                Icons.calendar_today,
              ),

              onTap: pickDateOfBirth,
            ),

            const SizedBox(height: 15),

            // ==================================================
            // FULL NAME
            // ==================================================

            TextField(
              controller: fullNameController,
              decoration:
                  const InputDecoration(
                labelText: "Full Name",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // GENDER
            // ==================================================

            DropdownButtonFormField<String>(
              initialValue: gender,

              decoration:
                  const InputDecoration(
                labelText: "Gender",
                border:
                    OutlineInputBorder(),
              ),

              items: genders.map(
                (item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                },
              ).toList(),

              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  gender = value;
                });
              },
            ),

            const SizedBox(height: 15),

            // ==================================================
            // NATIONALITY
            // ==================================================

            TextField(
              controller:
                  nationalityController,

              decoration:
                  const InputDecoration(
                labelText: "Nationality",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // ADDRESS
            // ==================================================

            TextField(
              controller:
                  addressController,

              maxLines: 2,

              decoration:
                  const InputDecoration(
                labelText: "Address",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // QUALIFICATION INFORMATION
            // ==================================================

            const Text(
              "Qualification Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue:
                  highestQualification,

              decoration:
                  const InputDecoration(
                labelText:
                    "Highest Qualification",
                border:
                    OutlineInputBorder(),
              ),

              items: qualifications.map(
                (item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                },
              ).toList(),

              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  highestQualification =
                      value;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  otherQualificationController,

              maxLines: 2,

              decoration:
                  const InputDecoration(
                labelText:
                    "Other Qualification(s)",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // QUALIFICATION DOCUMENT
            // ==================================================

            Card(
              elevation: 2,

              child: Padding(
                padding:
                    const EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      qualificationFile ==
                              null
                          ? "No qualification document selected"
                          : qualificationFile!
                              .name,

                      style:
                          const TextStyle(
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    ElevatedButton.icon(
                      onPressed:
                          pickQualification,

                      icon: const Icon(
                        Icons.upload_file,
                      ),

                      label: const Text(
                        "CHOOSE CERTIFICATE",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // CONTACT INFORMATION
            // ==================================================

            const Text(
              "Contact Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,

              keyboardType:
                  TextInputType.phone,

              decoration:
                  const InputDecoration(
                labelText:
                    "Phone Number",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,

              keyboardType:
                  TextInputType.emailAddress,

              decoration:
                  const InputDecoration(
                labelText:
                    "Email Address",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // EMPLOYMENT INFORMATION
            // ==================================================

            const Text(
              "Employment Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue:
                  selectedRole,

              decoration:
                  const InputDecoration(
                labelText:
                    "Staff Role",
                border:
                    OutlineInputBorder(),
              ),

              items: roles.map(
                (item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                },
              ).toList(),

              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedRole =
                      value;
                });
              },
            ),

            const SizedBox(height: 30),

            // ==================================================
            // ACCOUNT INFORMATION
            // ==================================================

            const Text(
              "Account Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // USERNAME
            // ==================================================

            TextField(
              controller:
                  usernameController,

              decoration:
                  const InputDecoration(
                labelText:
                    "Username",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // PASSWORD
            // ==================================================

            TextField(
              controller:
                  passwordController,

              obscureText: true,

              decoration:
                  const InputDecoration(
                labelText:
                    "Password",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // CONFIRM PASSWORD
            // ==================================================

            TextField(
              controller:
                  confirmPasswordController,

              obscureText: true,

              decoration:
                  const InputDecoration(
                labelText:
                    "Confirm Password",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // ACCOUNT STATUS
            // ==================================================

            DropdownButtonFormField<String>(
              initialValue:
                  accountStatus,

              decoration:
                  const InputDecoration(
                labelText:
                    "Account Status",
                border:
                    OutlineInputBorder(),
              ),

              items:
                  accountStatuses.map(
                (item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                },
              ).toList(),

              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  accountStatus =
                      value;
                });
              },
            ),

            const SizedBox(height: 30),

            // ==================================================
            // CREATE STAFF ACCOUNT BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed:
                    createAccount,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.amber,

                  foregroundColor:
                      Colors.black,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      8,
                    ),
                  ),
                ),

                child: const Text(
                  "CREATE STAFF ACCOUNT",

                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}