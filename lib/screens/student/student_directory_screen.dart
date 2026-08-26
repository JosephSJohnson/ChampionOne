import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../data/student_data.dart';
import '../../models/student_model.dart';
import '../../utils/file_storage.dart';
import 'student_profile_screen.dart';

class StudentDirectoryScreen extends StatefulWidget {
  const StudentDirectoryScreen({
    super.key,
  });

  @override
  State<StudentDirectoryScreen> createState() =>
      _StudentDirectoryScreenState();
}

class _StudentDirectoryScreenState
    extends State<StudentDirectoryScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String searchText = "";
  String selectedSchoolType =
      "All School Types";
  String selectedAdmissionCategory =
      "All Admission Categories";
  String selectedStatus =
      "All Status";

  bool loading = true;

  static const List<String> schoolTypes = [
    "All School Types",
    "Daycare / Early Childhood Education",
    "Primary School",
    "Primary → Secondary School",
    "Secondary School",
    "College",
    "University",
    "Vocational / Technical Training Institute",
  ];

  static const List<String> admissionCategories = [
    "All Admission Categories",
    "New Student",
    "Transfer Student",
    "Returning Student",
    "Promotion / Internal Progression",
    "Graduate / Advanced Entry",
  ];

  static const List<String> statuses = [
    "All Status",
    "Pending",
    "Active",
    "Suspended",
    "Graduated",
    "Withdrawn",
  ];

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    setState(() {
      loading = true;
    });

    await StudentData.loadStudents();

    if (!mounted) {
      return;
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<StudentModel> get filteredStudents {
    final search =
        searchText.trim().toLowerCase();

    return StudentData.studentList.where(
      (student) {
        final matchesSearch =
            search.isEmpty ||
                student.fullName
                    .toLowerCase()
                    .contains(search) ||
                student.studentID
                    .toLowerCase()
                    .contains(search) ||
                student.classGrade
                    .toLowerCase()
                    .contains(search) ||
                student.program
                    .toLowerCase()
                    .contains(search) ||
                student.previousSchool
                    .toLowerCase()
                    .contains(search);

        final matchesSchoolType =
            selectedSchoolType ==
                    "All School Types" ||
                student.schoolType ==
                    selectedSchoolType;

        final matchesAdmissionCategory =
            selectedAdmissionCategory ==
                    "All Admission Categories" ||
                student.admissionCategory ==
                    selectedAdmissionCategory;

        final matchesStatus =
            selectedStatus == "All Status" ||
                student.studentStatus ==
                    selectedStatus;

        return matchesSearch &&
            matchesSchoolType &&
            matchesAdmissionCategory &&
            matchesStatus;
      },
    ).toList();
  }

  Color statusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Suspended":
        return Colors.red;
      case "Graduated":
        return Colors.blue;
      case "Withdrawn":
        return Colors.grey.shade700;
      default:
        return Colors.grey;
    }
  }

  String displaySubtitle(
    StudentModel student,
  ) {
    final academic =
        student.program.isNotEmpty
            ? student.program
            : student.classGrade;

    if (academic.isEmpty) {
      return student.schoolType;
    }

    return "${student.schoolType} • $academic";
  }

  Future<Uint8List?> loadStudentPhoto(
    String path,
  ) async {
    if (path.isEmpty) {
      return null;
    }

    return FileStorage.readFile(path);
  }

  @override
  Widget build(BuildContext context) {
    final students = filteredStudents;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Student Directory",
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
                "${StudentData.studentList.length} Students",
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

      body: RefreshIndicator(
        onRefresh: loadStudents,

        child: Column(
          children: [
            // ====================================================
            // SEARCH
            // ====================================================

            Padding(
              padding:
                  const EdgeInsets.all(
                15,
              ),
              child: TextField(
                controller:
                    searchController,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Search Students",
                  hintText:
                      "Name, Student ID, Class, Program or Previous School",
                  prefixIcon:
                      Icon(
                    Icons.search,
                  ),
                  border:
                      OutlineInputBorder(),
                ),
                onChanged:
                    (value) {
                  setState(() {
                    searchText =
                        value;
                  });
                },
              ),
            ),

            // ====================================================
            // SCHOOL TYPE FILTER
            // ====================================================

            Padding(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 15,
              ),
              child:
                  DropdownButtonFormField<
                      String>(
                initialValue:
                    selectedSchoolType,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Filter By School Type",
                  border:
                      OutlineInputBorder(),
                ),
                items:
                    schoolTypes
                        .map(
                          (item) =>
                              DropdownMenuItem<
                                  String>(
                            value:
                                item,
                            child:
                                Text(
                              item,
                            ),
                          ),
                        )
                        .toList(),
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
            ),

            const SizedBox(
              height: 10,
            ),

            // ====================================================
            // ADMISSION CATEGORY
            // ====================================================

            Padding(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 15,
              ),
              child:
                  DropdownButtonFormField<
                      String>(
                initialValue:
                    selectedAdmissionCategory,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Filter By Admission Category",
                  border:
                      OutlineInputBorder(),
                ),
                items:
                    admissionCategories
                        .map(
                          (item) =>
                              DropdownMenuItem<
                                  String>(
                            value:
                                item,
                            child:
                                Text(
                              item,
                            ),
                          ),
                        )
                        .toList(),
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
            ),

            const SizedBox(
              height: 10,
            ),

            // ====================================================
            // STATUS FILTER
            // ====================================================

            Padding(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 15,
              ),
              child:
                  DropdownButtonFormField<
                      String>(
                initialValue:
                    selectedStatus,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Filter By Status",
                  border:
                      OutlineInputBorder(),
                ),
                items:
                    statuses
                        .map(
                          (item) =>
                              DropdownMenuItem<
                                  String>(
                            value:
                                item,
                            child:
                                Text(
                              item,
                            ),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    selectedStatus =
                        value;
                  });
                },
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // ====================================================
            // RESULTS
            // ====================================================

            Expanded(
              child: loading
                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )
                  : students.isEmpty
                      ? ListView(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(
                              height: 140,
                            ),
                            Center(
                              child:
                                  Column(
                                children: [
                                  Icon(
                                    Icons
                                        .school_outlined,
                                    size:
                                        64,
                                    color:
                                        Colors.grey,
                                  ),
                                  SizedBox(
                                    height:
                                        12,
                                  ),
                                  Text(
                                    "No Students Found",
                                    style:
                                        TextStyle(
                                      fontSize:
                                          20,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        8,
                                  ),
                                  Text(
                                    "Try changing your search or filters.",
                                    textAlign:
                                        TextAlign.center,
                                    style:
                                        TextStyle(
                                      color:
                                          Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          padding:
                              const EdgeInsets.all(
                            15,
                          ),
                          itemCount:
                              students.length,
                          itemBuilder:
                              (
                            context,
                            index,
                          ) {
                            final student =
                                students[index];

                            return Card(
                              elevation:
                                  4,
                              margin:
                                  const EdgeInsets.only(
                                bottom:
                                    15,
                              ),
                              child:
                                  InkWell(
                                onTap:
                                    () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              StudentProfileScreen(
                                        student:
                                            student,
                                      ),
                                    ),
                                  );

                                  await loadStudents();
                                },

                                borderRadius:
                                    BorderRadius.circular(
                                  4,
                                ),

                                child:
                                    Padding(
                                  padding:
                                      const EdgeInsets.all(
                                    15,
                                  ),
                                  child:
                                      Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      FutureBuilder<
                                          Uint8List?>(
                                        future:
                                            loadStudentPhoto(
                                          student
                                              .studentPhoto,
                                        ),
                                        builder:
                                            (
                                          context,
                                          snapshot,
                                        ) {
                                          final bytes =
                                              snapshot.data;

                                          return CircleAvatar(
                                            radius:
                                                30,
                                            backgroundImage:
                                                bytes != null
                                                    ? MemoryImage(
                                                        bytes,
                                                      )
                                                    : null,
                                            child:
                                                bytes == null
                                                    ? Text(
                                                        student.fullName.isNotEmpty
                                                            ? student.fullName[0].toUpperCase()
                                                            : "?",
                                                        style:
                                                            const TextStyle(
                                                          fontSize:
                                                              22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    : null,
                                          );
                                        },
                                      ),

                                      const SizedBox(
                                        width:
                                            15,
                                      ),

                                      Expanded(
                                        child:
                                            Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              student
                                                  .fullName,
                                              style:
                                                  const TextStyle(
                                                fontSize:
                                                    20,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(
                                              height:
                                                  4,
                                            ),

                                            Text(
                                              "ID: ${student.studentID}",
                                            ),

                                            Text(
                                              displaySubtitle(
                                                student,
                                              ),
                                            ),

                                            if (student
                                                .admissionCategory
                                                .isNotEmpty)
                                              Text(
                                                "Admission: ${student.admissionCategory}",
                                              ),

                                            const SizedBox(
                                              height:
                                                  8,
                                            ),

                                            Wrap(
                                              spacing:
                                                  8,
                                              runSpacing:
                                                  5,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal:
                                                        10,
                                                    vertical:
                                                        5,
                                                  ),
                                                  decoration:
                                                      BoxDecoration(
                                                    color:
                                                        Colors.blue.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      15,
                                                    ),
                                                  ),
                                                  child:
                                                      Text(
                                                    student.schoolType,
                                                    style:
                                                        TextStyle(
                                                      fontSize:
                                                          12,
                                                      color:
                                                          Colors.blue.shade900,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal:
                                                        10,
                                                    vertical:
                                                        5,
                                                  ),
                                                  decoration:
                                                      BoxDecoration(
                                                    color:
                                                        statusColor(
                                                      student.studentStatus,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      15,
                                                    ),
                                                  ),
                                                  child:
                                                      Text(
                                                    student.studentStatus,
                                                    style:
                                                        const TextStyle(
                                                      color:
                                                          Colors.white,
                                                      fontSize:
                                                          12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      const Icon(
                                        Icons
                                            .arrow_forward_ios,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}