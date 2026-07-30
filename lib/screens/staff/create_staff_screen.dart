import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/staff_model.dart';
import '../../data/staff_data.dart';
import '../../utils/id_generator.dart';

class CreateStaffScreen extends StatefulWidget {
  const CreateStaffScreen({super.key});

  @override
  State<CreateStaffScreen> createState() =>
      _CreateStaffScreenState();
}

class _CreateStaffScreenState
    extends State<CreateStaffScreen> {
  //========================
  // Controllers
  //========================

  final fullNameController = TextEditingController();
  final nationalityController = TextEditingController();
  final addressController = TextEditingController();

  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final otherQualificationController =
      TextEditingController();

  //========================
  // Images & Documents
  //========================

  XFile? selectedImage;
  PlatformFile? qualificationFile;

  //========================
  // Staff Information
  //========================

 String staffID = "";

  String gender = "Male";
  String selectedRole = "Teacher";
  String highestQualification =
      "High School Diploma";

  String accountStatus = "Pending";

  DateTime? dateOfBirth;

  //========================
  // Dropdown Lists
  //========================

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

  //========================
  // Pick Date of Birth
  //========================

  Future<void> pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dateOfBirth = picked;
      });
    }
  }

  //========================
  // Pick Staff Photo
  //========================

  Future<void> pickStaffImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  //========================
  // Pick Qualification File
  //========================

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

    if (result != null) {
      setState(() {
        qualificationFile =
            result.files.first;
      });
    }
  }

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

    void createAccount() {
    if (fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the staff full name."),
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

    if (passwordController.text !=
        confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match."),
        ),
      );
      return;
    }

    staffID = IDGenerator.generateStaffID();

    final StaffModel staff = StaffModel(
      staffID: staffID,

      profileImage: selectedImage?.path ?? "",

      qualificationDocument:
          qualificationFile?.path ?? "",

      fullName: fullNameController.text.trim(),

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
          otherQualificationController.text.trim(),

      phone: phoneController.text.trim(),

      email: emailController.text.trim(),

      role: selectedRole,

      username:
          usernameController.text.trim(),

      password:
          passwordController.text,

      accountStatus:
          accountStatus,

      createdDate:
          DateTime.now(),
    );

    StaffData.addStaff(staff);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Staff account created successfully.\nID: $staffID",
        ),
      ),
    );

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
  qualificationFile = null;

  gender = "Male";
  selectedRole = "Teacher";
  highestQualification = "High School Diploma";
  accountStatus = "Pending";
  dateOfBirth = null;

  staffID = "";
});
}

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Staff Account"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Staff Information",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Center(
              child: Column(
                children: [

                  CircleAvatar(
                    radius: 50,
                    backgroundImage: selectedImage != null
                        ? NetworkImage(selectedImage!.path)
                        : null,
                    child: selectedImage == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                          )
                        : null,
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton.icon(
                    onPressed: pickStaffImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("SELECT STAFF PHOTO"),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.grey),
              ),

              title: Text(
                dateOfBirth == null
                    ? "Select Date of Birth"
                    : "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}",
              ),

              trailing: const Icon(Icons.calendar_today),

              onTap: pickDateOfBirth,
            ),

            const SizedBox(height: 15),

            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: gender,

              decoration: const InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
              ),

              items: genders.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: nationalityController,
              decoration: const InputDecoration(
                labelText: "Nationality",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),


                        const Text(
              "Qualification Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: highestQualification,
              decoration: const InputDecoration(
                labelText: "Highest Qualification",
                border: OutlineInputBorder(),
              ),
              items: qualifications.map((qualification) {
                return DropdownMenuItem(
                  value: qualification,
                  child: Text(qualification),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  highestQualification = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: otherQualificationController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Other Qualification(s)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      qualificationFile == null
                          ? "No qualification document selected"
                          : qualificationFile!.name,
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      onPressed: pickQualification,
                      icon: const Icon(Icons.upload_file),
                      label: const Text(
                        "Choose Certificate",
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Contact Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

                        const Text(
              "Employment Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: "Staff Role",
                border: OutlineInputBorder(),
              ),
              items: roles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: TextEditingController(
                text: staffID,
              ),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Staff ID",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: accountStatus,
              decoration: const InputDecoration(
                labelText: "Account Status",
                border: OutlineInputBorder(),
              ),
              items: accountStatuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  accountStatus = value!;
                });
              },
            ),

            const SizedBox(height: 30),

                        SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  "CREATE STAFF ACCOUNT",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}