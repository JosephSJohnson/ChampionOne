import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:universal_html/html.dart' as html;

import '../../models/staff_model.dart';
import '../../data/staff_data.dart';
import '../../database/database_helper.dart';
import '../../utils/file_storage.dart';

import 'edit_staff_screen.dart';
import 'staff_documents_screen.dart';

class StaffProfileScreen extends StatefulWidget {
  final StaffModel staff;

  const StaffProfileScreen({
    super.key,
    required this.staff,
  });

  @override
  State<StaffProfileScreen> createState() =>
      _StaffProfileScreenState();
}

class _StaffProfileScreenState
    extends State<StaffProfileScreen> {
  String selectedStatus = "";
  late StaffModel staff;

  // ============================================================
  // LOAD STAFF PHOTO
  // ============================================================

  Future<Uint8List?> _loadStaffPhoto(
    String imagePath,
  ) async {
    if (imagePath.isEmpty) {
      return null;
    }

    return FileStorage.readFile(imagePath);
  }

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    staff = widget.staff;
    selectedStatus = widget.staff.accountStatus;
  }

  // ============================================================
  // REFRESH STAFF
  // ============================================================

  void refreshStaff() {
    final updatedStaff =
        StaffData.getStaffByID(staff.staffID);

    if (updatedStaff != null) {
      staff = updatedStaff;
      selectedStatus = updatedStaff.accountStatus;
    }
  }

  // ============================================================
  // GET FILE NAME
  // ============================================================

  String _getFileName(String filePath) {
    if (filePath.isEmpty) {
      return "";
    }

    final normalized =
        filePath.replaceAll('\\', '/');

    return normalized.split('/').last;
  }

  // ============================================================
  // GET MIME TYPE
  // ============================================================

  String _getMimeType(String fileName) {
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
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    }

    if (lower.endsWith('.xls')) {
      return 'application/vnd.ms-excel';
    }

    if (lower.endsWith('.xlsx')) {
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    }

    if (lower.endsWith('.ppt')) {
      return 'application/vnd.ms-powerpoint';
    }

    if (lower.endsWith('.pptx')) {
      return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
    }

    return 'application/octet-stream';
  }

  // ============================================================
  // OPEN QUALIFICATION CERTIFICATE
  // ============================================================

  Future<void> openQualificationCertificate() async {
    if (staff.qualificationDocument.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No qualification document uploaded.",
          ),
        ),
      );

      return;
    }

    try {
      final bytes =
          await FileStorage.readFile(
        staff.qualificationDocument,
      );

      if (!mounted) {
        return;
      }

      if (bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Unable to open document. "
              "The stored certificate could not be found.",
            ),
          ),
        );

        return;
      }

      final fileName =
          _getFileName(
        staff.qualificationDocument,
      );

      // ========================================================
      // CHROME / WEB
      // ========================================================

      if (kIsWeb) {
        final mimeType =
            _getMimeType(fileName);

        final blob = html.Blob(
          [bytes],
          mimeType,
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
            html.Url.revokeObjectUrl(url);
          },
        );

        return;
      }

      // ========================================================
      // WINDOWS / DESKTOP
      // ========================================================

      final result = await OpenFilex.open(
        staff.qualificationDocument,
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
            "Unable to open document: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // DELETE STAFF
  // ============================================================

  Future<void> deleteStaff() async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Delete Staff",
          ),
          content: Text(
            "Are you sure you want to delete\n\n"
            "${staff.fullName}\n"
            "${staff.staffID}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                "Cancel",
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
                "Delete",
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await DatabaseHelper.instance.deleteStaff(
        staff.staffID,
      );

      StaffData.deleteStaff(
        staff.staffID,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to delete staff: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // CHANGE ACCOUNT STATUS
  // ============================================================

  Future<void> changeAccountStatus() async {
  String dialogStatus = selectedStatus;

  final newStatus = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text(
          "Change Account Status",
        ),

        content: StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return RadioGroup<String>(
              groupValue: dialogStatus,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setDialogState(() {
                  dialogStatus = value;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const RadioListTile<String>(
                    value: "Active",
                    title: Text("🟢 Active"),
                  ),

                  const RadioListTile<String>(
                    value: "Pending",
                    title: Text("🟡 Pending"),
                  ),

                  const RadioListTile<String>(
                    value: "Suspended",
                    title: Text("🔴 Suspended"),
                  ),

                  const RadioListTile<String>(
                    value: "Terminated",
                    title: Text("⚫ Terminated"),
                  ),

                  const RadioListTile<String>(
                    value: "Resigned",
                    title: Text("🔵 Resigned"),
                  ),
                ],
              ),
            );
          },
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              "Cancel",
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(
                dialogStatus,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              "Save",
            ),
          ),
        ],
      );
    },
  );

  if (newStatus == null ||
      newStatus == selectedStatus) {
    return;
  }

  final updatedStaff = StaffModel(
    staffID: staff.staffID,
    profileImage: staff.profileImage,
    qualificationDocument:
        staff.qualificationDocument,
    fullName: staff.fullName,
    dateOfBirth: staff.dateOfBirth,
    gender: staff.gender,
    nationality: staff.nationality,
    address: staff.address,
    qualification: staff.qualification,
    otherQualification:
        staff.otherQualification,
    phone: staff.phone,
    email: staff.email,
    role: staff.role,
    username: staff.username,
    password: staff.password,
    accountStatus: newStatus,
    createdDate: staff.createdDate,
  );

  try {
    await DatabaseHelper.instance.updateStaff(
      updatedStaff.toMap(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      staff = updatedStaff;
      selectedStatus = newStatus;
    });

    StaffData.loadStaff();
  } catch (e) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Failed to update account status: $e",
        ),
      ),
    );
  }
}

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Staff Profile",
        ),
        backgroundColor:
            Colors.amber,
        foregroundColor:
            Colors.black,
        actions: [
          // ======================================================
          // EDIT STAFF
          // ======================================================

          IconButton(
            icon: const Icon(
              Icons.edit,
            ),
            tooltip: "Edit Staff",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditStaffScreen(
                    staff: staff,
                  ),
                ),
              );

              if (!mounted) {
                return;
              }

              setState(() {});
            },
          ),

          // ======================================================
          // DELETE STAFF
          // ======================================================

          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            tooltip: "Delete Staff",
            onPressed: deleteStaff,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [
            // ====================================================
            // STAFF PHOTO
            // ====================================================

            FutureBuilder<Uint8List?>(
              future: _loadStaffPhoto(
                staff.profileImage,
              ),
              builder: (
                context,
                snapshot,
              ) {
                final imageBytes =
                    snapshot.data;

                return CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      imageBytes != null
                          ? MemoryImage(
                              imageBytes,
                            )
                          : null,
                  child:
                      imageBytes == null
                          ? Text(
                              staff.fullName
                                      .isNotEmpty
                                  ? staff
                                      .fullName[0]
                                      .toUpperCase()
                                  : "?",
                              style:
                                  const TextStyle(
                                fontSize: 40,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            )
                          : null,
                );
              },
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              staff.fullName,
              style:
                  const TextStyle(
                fontSize: 26,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // ====================================================
            // STAFF INFORMATION
            // ====================================================

            _buildInfo(
              "Staff ID",
              staff.staffID,
            ),
            _buildInfo(
              "Role",
              staff.role,
            ),
            _buildInfo(
              "Gender",
              staff.gender,
            ),
            _buildInfo(
              "Date of Birth",
              staff.dateOfBirth,
            ),
            _buildInfo(
              "Nationality",
              staff.nationality,
            ),
            _buildInfo(
              "Address",
              staff.address,
            ),
            _buildInfo(
              "Qualification",
              staff.qualification,
            ),
            _buildInfo(
              "Other Qualification",
              staff.otherQualification,
            ),

            // ====================================================
            // QUALIFICATION CERTIFICATE
            // ====================================================

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  15,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.description,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Qualification Certificate",
                          style:
                              TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      staff
                              .qualificationDocument
                              .isEmpty
                          ? "No document uploaded"
                          : _getFileName(
                              staff
                                  .qualificationDocument,
                            ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    if (staff
                        .qualificationDocument
                        .isNotEmpty)
                      SizedBox(
                        width:
                            double.infinity,
                        child:
                            ElevatedButton
                                .icon(
                          onPressed:
                              openQualificationCertificate,
                          icon:
                              const Icon(
                            Icons.open_in_new,
                          ),
                          label:
                              const Text(
                            "VIEW CERTIFICATE",
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ====================================================
            // CONTACT INFORMATION
            // ====================================================

            _buildInfo(
              "Phone",
              staff.phone,
            ),
            _buildInfo(
              "Email",
              staff.email,
            ),
            _buildInfo(
              "Username",
              staff.username,
            ),

            // ====================================================
            // ACCOUNT STATUS
            // ====================================================

            Align(
              alignment:
                  Alignment.centerLeft,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text(
                    "Account Status",
                    style:
                        TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Chip(
                    label: Text(
                      selectedStatus,
                    ),
                    backgroundColor:
                        selectedStatus ==
                                "Active"
                            ? Colors.green
                            : selectedStatus ==
                                    "Pending"
                                ? Colors.orange
                                : selectedStatus ==
                                        "Suspended"
                                    ? Colors.red
                                    : selectedStatus ==
                                            "Terminated"
                                        ? Colors.black
                                        : selectedStatus ==
                                                "Resigned"
                                            ? Colors.blue
                                            : Colors.grey,
                    labelStyle:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // ====================================================
            // CHANGE ACCOUNT STATUS
            // ====================================================

            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton
                      .icon(
                onPressed:
                    changeAccountStatus,
                icon:
                    const Icon(
                  Icons.manage_accounts,
                ),
                label:
                    const Text(
                  "CHANGE ACCOUNT STATUS",
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
              height: 20,
            ),

            // ====================================================
            // STAFF DOCUMENTS
            // ====================================================

            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton
                      .icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              StaffDocumentsScreen(
                    staff: staff,
                  ),
                    ),
                  );
                },
                icon:
                    const Icon(
                  Icons.folder,
                ),
                label:
                    const Text(
                  "STAFF DOCUMENTS",
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
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFORMATION CARD
  // ============================================================

  Widget _buildInfo(
    String title,
    String value,
  ) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: ListTile(
        title: Text(
          title,
          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value.isEmpty ? "-" : value,
        ),
      ),
    );
  }
}