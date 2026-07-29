import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/staff_model.dart';
import '../../data/staff_data.dart';

class CreateStaffV2Screen extends StatefulWidget {
  const CreateStaffV2Screen({super.key});

  @override
  State<CreateStaffV2Screen> createState() =>
      _CreateStaffV2ScreenState();
}

class _CreateStaffV2ScreenState
    extends State<CreateStaffV2Screen> {

 final fullNameController = TextEditingController();
final phoneController = TextEditingController();
final emailController = TextEditingController();
final nationalityController = TextEditingController();
final addressController = TextEditingController();

final usernameController = TextEditingController();
final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();

final qualificationController = TextEditingController();
final otherQualificationController = TextEditingController();

String gender = "Male";
String role = "Teacher";
String accountStatus = "Active";

DateTime? selectedDate;

XFile? profileImage;

PlatformFile? qualificationFile;

String generateStaffID() {
  return "CHAMP${(StaffData.staffList.length + 1).toString().padLeft(3, '0')}";
}

final ImagePicker picker = ImagePicker();

Future<void> pickProfileImage() async {
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image != null) {
    setState(() {
      profileImage = image;
    });
  }
}

Future<void> pickQualificationDocument() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
  );

  if (result != null) {
    setState(() {
      qualificationFile = result.files.first;
    });
  }
}

Future<void> selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime(2000),
    firstDate: DateTime(1950),
    lastDate: DateTime.now(),
  );

  if (picked != null) {
    setState(() {
      selectedDate = picked;
    });
  }
}

@override
void dispose() {
  fullNameController.dispose();
  phoneController.dispose();
  emailController.dispose();
  nationalityController.dispose();
  addressController.dispose();

  usernameController.dispose();
  passwordController.dispose();
  confirmPasswordController.dispose();

  qualificationController.dispose();
  otherQualificationController.dispose();

  super.dispose();
}

void createStaff() {

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

  if (passwordController.text != confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Passwords do not match."),
      ),
    );
    return;
  }

  final staff = StaffModel(
    staffID:
profileImage:
qualificationDocument:

fullName:
dateOfBirth:
gender:
nationality:
address:

qualification:
otherQualification:

phone:
email:

role:

username:
password:

accountStatus:

createdDate:
  );

  StaffData.addStaff(staff);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Staff account created successfully."),
    ),
  );

  Navigator.pop(context);
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Create Staff"),
      backgroundColor: Colors.amber,
      foregroundColor: Colors.black,
    ),

    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Center(
  child: GestureDetector(
    onTap: pickProfileImage,

    child: CircleAvatar(
      radius: 60,

      backgroundImage: profileImage != null
          ? NetworkImage(profileImage!.path)
          : null,

      child: profileImage == null
          ? const Icon(
              Icons.camera_alt,
              size: 40,
            )
          : null,
    ),
  ),
),

const SizedBox(height: 20),

Text(
  "Staff ID",
  style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.grey.shade700,
  ),
),

const SizedBox(height: 5),

Container(
  width: double.infinity,
  padding: const EdgeInsets.all(15),

  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(10),
  ),

  child: Text(
    generateStaffID(),
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 20),
const Text(
  "PERSONAL INFORMATION",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
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
  items: const [
    DropdownMenuItem(
      value: "Male",
      child: Text("Male"),
    ),
    DropdownMenuItem(
      value: "Female",
      child: Text("Female"),
    ),
  ],
  onChanged: (value) {
    setState(() {
      gender = value!;
    });
  },
),

const SizedBox(height: 15),

InkWell(
  onTap: () => selectDate(context),
  child: InputDecorator(
    decoration: const InputDecoration(
      labelText: "Date of Birth",
      border: OutlineInputBorder(),
    ),
    child: Text(
      selectedDate == null
          ? "Select Date"
          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
    ),
  ),
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
  "QUALIFICATIONS",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

TextField(
  controller: qualificationController,
  decoration: const InputDecoration(
    labelText: "Highest Qualification",
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 15),

TextField(
  controller: otherQualificationController,
  decoration: const InputDecoration(
    labelText: "Other Qualification(s)",
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 15),

ElevatedButton.icon(
  onPressed: pickQualificationDocument,

  icon: const Icon(Icons.upload_file),

  label: Text(
    qualificationFile == null
        ? "Upload Qualification Document"
        : qualificationFile!.name,
  ),

  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 55),
  ),
),

const SizedBox(height: 25),

const Text(
  "CONTACT INFORMATION",
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
    prefixIcon: Icon(Icons.phone),
  ),
),

const SizedBox(height: 15),

TextField(
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: const InputDecoration(
    labelText: "Email Address",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.email),
  ),
),

const SizedBox(height: 25),

const Text(
  "EMPLOYMENT INFORMATION",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

DropdownButtonFormField<String>(
  value: role,

  decoration: const InputDecoration(
    labelText: "Role",
    border: OutlineInputBorder(),
  ),

  items: const [

    DropdownMenuItem(
      value: "Teacher",
      child: Text("Teacher"),
    ),

    DropdownMenuItem(
      value: "Administrator",
      child: Text("Administrator"),
    ),

    DropdownMenuItem(
      value: "Accountant",
      child: Text("Accountant"),
    ),

    DropdownMenuItem(
      value: "Secretary",
      child: Text("Secretary"),
    ),

    DropdownMenuItem(
      value: "Support Staff",
      child: Text("Support Staff"),
    ),

  ],

  onChanged: (value) {

    setState(() {

      role = value!;

    });

  },

),

const SizedBox(height: 15),

DropdownButtonFormField<String>(
  value: accountStatus,

  decoration: const InputDecoration(
    labelText: "Account Status",
    border: OutlineInputBorder(),
  ),

  items: const [

    DropdownMenuItem(
      value: "Active",
      child: Text("Active"),
    ),

    DropdownMenuItem(
      value: "Pending",
      child: Text("Pending"),
    ),

    DropdownMenuItem(
      value: "Inactive",
      child: Text("Inactive"),
    ),

  ],

  onChanged: (value) {

    setState(() {

      accountStatus = value!;

    });

  },

),

const SizedBox(height: 25),

const Text(
  "LOGIN INFORMATION",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

TextField(
  controller: usernameController,

  decoration: const InputDecoration(
    labelText: "Username",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.person),
  ),

),

const SizedBox(height: 15),

TextField(
  controller: passwordController,

  obscureText: true,

  decoration: const InputDecoration(
    labelText: "Password",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.lock),
  ),

),

const SizedBox(height: 15),

TextField(
  controller: confirmPasswordController,

  obscureText: true,

  decoration: const InputDecoration(
    labelText: "Confirm Password",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.lock_outline),
  ),

),

const SizedBox(height: 30),



SizedBox(
  width: double.infinity,
  height: 55,

  child: ElevatedButton(

    onPressed: createStaff,

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