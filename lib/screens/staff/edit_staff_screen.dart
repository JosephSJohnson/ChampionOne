import 'package:flutter/material.dart';

import '../../models/staff_model.dart';
import '../../data/staff_data.dart';

class EditStaffScreen extends StatefulWidget {
  final StaffModel staff;

  const EditStaffScreen({
    super.key,
    required this.staff,
  });

  @override
  State<EditStaffScreen> createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends State<EditStaffScreen> {
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController nationalityController;

  @override
  void initState() {
    super.initState();

    fullNameController =
        TextEditingController(text: widget.staff.fullName);

    phoneController =
        TextEditingController(text: widget.staff.phone);

    emailController =
        TextEditingController(text: widget.staff.email);

    nationalityController =
        TextEditingController(text: widget.staff.nationality);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    nationalityController.dispose();

    super.dispose();
  }

  void saveChanges() {
    StaffModel updatedStaff = StaffModel(
      staffID: widget.staff.staffID,
      profileImage: widget.staff.profileImage,
      qualificationDocument:
          widget.staff.qualificationDocument,

      fullName: fullNameController.text,
      dateOfBirth: widget.staff.dateOfBirth,
      gender: widget.staff.gender,
      nationality: nationalityController.text,
      address: widget.staff.address,

      qualification: widget.staff.qualification,
      otherQualification:
          widget.staff.otherQualification,

      phone: phoneController.text,
      email: emailController.text,

      role: widget.staff.role,

      username: widget.staff.username,
      password: widget.staff.password,

      accountStatus: widget.staff.accountStatus,

      createdDate: widget.staff.createdDate,
    );

    StaffData.updateStaff(updatedStaff);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Staff information updated successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Staff"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
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
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  "SAVE CHANGES",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}