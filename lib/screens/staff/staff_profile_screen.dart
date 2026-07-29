import 'package:flutter/material.dart';
import '../../models/staff_model.dart';
import '../../data/staff_data.dart';
import 'edit_staff_screen.dart';

class StaffProfileScreen extends StatefulWidget {
  final StaffModel staff;

  const StaffProfileScreen({
    super.key,
    required this.staff,
  });

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {

  late StaffModel staff;

  @override
  void initState() {
    super.initState();
    staff = widget.staff;
  }

  void refreshStaff() {
    staff = StaffData.staffList.firstWhere(
      (item) => item.staffID == staff.staffID,
    );
  }

  @override
  Widget build(BuildContext context) {

    refreshStaff();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Profile"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Edit Staff",
            onPressed: () async {

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditStaffScreen(
                    staff: staff,
                  ),
                ),
              );

              setState(() {});
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            CircleAvatar(
              radius: 60,
              backgroundImage: staff.profileImage.isNotEmpty
                  ? NetworkImage(staff.profileImage)
                  : null,
              child: staff.profileImage.isEmpty
                  ? Text(
                      staff.fullName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),

            const SizedBox(height: 20),

            Text(
              staff.fullName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            _buildInfo("Staff ID", staff.staffID),
            _buildInfo("Role", staff.role),
            _buildInfo("Gender", staff.gender),
            _buildInfo("Nationality", staff.nationality),
            _buildInfo("Date of Birth", staff.dateOfBirth),
            _buildInfo("Qualification", staff.qualification),
            _buildInfo("Other Qualification(s)", staff.otherQualification),
            _buildInfo(
  "Qualification Certificate",
  staff.qualificationDocument.isEmpty
      ? "No document uploaded"
      : staff.qualificationDocument.split('/').last,
),
            _buildInfo("Phone", staff.phone),
            _buildInfo("Email", staff.email),
            _buildInfo("Username", staff.username),
            _buildInfo("Status", staff.accountStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value.isEmpty ? "-" : value,
        ),
      ),
    );
  }
}