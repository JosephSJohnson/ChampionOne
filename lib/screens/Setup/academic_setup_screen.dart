import 'package:flutter/material.dart';

import '../../database/database_helper.dart';

class AcademicSetupScreen extends StatefulWidget {
  const AcademicSetupScreen({
    super.key,
  });

  @override
  State<AcademicSetupScreen> createState() =>
      _AcademicSetupScreenState();
}

class _AcademicSetupScreenState
    extends State<AcademicSetupScreen> {
  // ============================================================
  // STATE
  // ============================================================

  bool isLoading = true;
  bool isSaving = false;

  List<Map<String, dynamic>> academicYears = [];

  List<Map<String, dynamic>> academicTerms = [];

  int? selectedAcademicYearId;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadAcademicYears();
  }

  // ============================================================
  // LOAD ACADEMIC YEARS
  // ============================================================

  Future<void> _loadAcademicYears() async {
    try {
      final years =
          await DatabaseHelper.instance
              .getAcademicYears();

      if (!mounted) {
        return;
      }

      int? currentYearId;

      for (final year in years) {
        if (year['isCurrent'] == 1) {
          currentYearId =
              year['id'] as int?;

          break;
        }
      }

      setState(() {
        academicYears = years;
        selectedAcademicYearId =
            currentYearId ??
                (years.isNotEmpty
                    ? years.first['id'] as int?
                    : null);
        isLoading = false;
      });

      if (selectedAcademicYearId != null) {
        await _loadAcademicTerms(
          selectedAcademicYearId!,
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      _showMessage(
        "Unable to load academic years: $e",
      );
    }
  }

  // ============================================================
  // LOAD TERMS
  // ============================================================

  Future<void> _loadAcademicTerms(
    int academicYearId,
  ) async {
    try {
      final terms =
          await DatabaseHelper.instance
              .getAcademicTerms(
        academicYearId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        academicTerms = terms;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        "Unable to load academic terms: $e",
      );
    }
  }

  // ============================================================
  // SELECT ACADEMIC YEAR
  // ============================================================

  Future<void> _selectAcademicYear(
    int? yearId,
  ) async {
    if (yearId == null) {
      return;
    }

    setState(() {
      selectedAcademicYearId = yearId;
      academicTerms = [];
    });

    await _loadAcademicTerms(
      yearId,
    );
  }

  // ============================================================
  // SELECTED YEAR
  // ============================================================

  Map<String, dynamic>?
      get selectedAcademicYear {
    if (selectedAcademicYearId == null) {
      return null;
    }

    for (final year in academicYears) {
      if (year['id'] ==
          selectedAcademicYearId) {
        return year;
      }
    }

    return null;
  }

  // ============================================================
  // ADD TERM
  // ============================================================

  Future<void> _addTerm() async {
    if (selectedAcademicYearId == null) {
      _showMessage(
        "Please select an academic year.",
      );

      return;
    }

    if (isSaving) {
      return;
    }

    final nextTermNumber =
        academicTerms.length + 1;

    if (nextTermNumber > 10) {
      _showMessage(
        "A maximum of 10 terms is allowed.",
      );

      return;
    }

    final termNameController =
        TextEditingController(
      text: "Term $nextTermNumber",
    );

    String termStatus = "Active";

    final result =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              title: Text(
                "Add Term $nextTermNumber",
              ),
              content:
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                          termNameController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Term Name",
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<
                        String>(
                      initialValue:
                          termStatus,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Status",
                        border:
                            OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Active",
                          child:
                              Text("Active"),
                        ),
                        DropdownMenuItem(
                          value: "Closed",
                          child:
                              Text("Closed"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setDialogState(() {
                          termStatus =
                              value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      false,
                    );
                  },
                  child:
                      const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (termNameController
                        .text
                        .trim()
                        .isEmpty) {
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  child:
                      const Text("SAVE TERM"),
                ),
              ],
            );
          },
        );
      },
    );

    final termName =
        termNameController.text.trim();

    termNameController.dispose();

    if (result != true ||
        termName.isEmpty) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await DatabaseHelper.instance
          .createAcademicTerm(
        {
          'academicYearId':
              selectedAcademicYearId,
          'termNumber':
              nextTermNumber,
          'termName':
              termName,
          'status':
              termStatus,
        },
      );

      await _loadAcademicTerms(
        selectedAcademicYearId!,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        "$termName created successfully.",
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        e.toString().replaceFirst(
              "Exception: ",
              "",
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
  // DELETE TERM
  // ============================================================

  Future<void> _deleteTerm(
    Map<String, dynamic> term,
  ) async {
    final termId =
        term['id'] as int?;

    if (termId == null) {
      return;
    }

    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text("Delete Term"),
          content: Text(
            "Are you sure you want to delete "
            "${term['termName']}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child:
                  const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child:
                  const Text("DELETE"),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await DatabaseHelper.instance
          .deleteAcademicTerm(
        termId,
      );

      await _loadAcademicTerms(
        selectedAcademicYearId!,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        "Term deleted successfully.",
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        "Unable to delete term: $e",
      );
    }
  }

  // ============================================================
  // STATUS
  // ============================================================

  bool get selectedYearIsCurrent {
    return selectedAcademicYear?[
            'isCurrent'] ==
        1;
  }

  String get selectedYearName {
    return selectedAcademicYear?[
                'academicYear']
            ?.toString() ??
        "No Academic Year";
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
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
  // YEAR DROPDOWN
  // ============================================================

  Widget _academicYearSelector() {
    if (academicYears.isEmpty) {
      return Container(
        width: double.infinity,
        padding:
            const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border:
              Border.all(color: Colors.grey),
          borderRadius:
              BorderRadius.circular(8),
        ),
        child: const Text(
          "No academic year has been created yet.",
        ),
      );
    }

    return DropdownButtonFormField<int>(
      initialValue:
          selectedAcademicYearId,
      decoration:
          const InputDecoration(
        labelText:
            "Academic Year",
        border:
            OutlineInputBorder(),
      ),
      items: academicYears
          .map(
            (year) {
              final id =
                  year['id'] as int;

              final name =
                  year['academicYear']
                          ?.toString() ??
                      "";

              final current =
                  year['isCurrent'] == 1;

              return DropdownMenuItem<int>(
                value: id,
                child: Text(
                  current
                      ? "$name (CURRENT)"
                      : "$name (PREVIOUS)",
                ),
              );
            },
          )
          .toList(),
      onChanged:
          _selectAcademicYear,
    );
  }

  // ============================================================
  // YEAR INFORMATION
  // ============================================================

  Widget _yearInformation() {
    final year =
        selectedAcademicYear;

    if (year == null) {
      return const SizedBox.shrink();
    }

    final openingDate =
        year['openingDate']
                ?.toString() ??
            "";

    final closingDate =
        year['closingDate']
                ?.toString() ??
            "";

    final numberOfTerms =
        year['numberOfTerms']
                ?.toString() ??
            "";

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedYearName,
                    style:
                        const TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  selectedYearIsCurrent
                      ? "CURRENT"
                      : "PREVIOUS",
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    color:
                        selectedYearIsCurrent
                            ? Colors.green
                            : Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Opening Date: $openingDate",
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Closing Date: $closingDate",
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Configured Terms: $numberOfTerms",
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TERM CARD
  // ============================================================

  Widget _termCard(
    Map<String, dynamic> term,
  ) {
    final termName =
        term['termName']
                ?.toString() ??
            "";

    final status =
        term['status']
                ?.toString() ??
            "Active";

    final termNumber =
        term['termNumber']
                ?.toString() ??
            "";

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            termNumber,
          ),
        ),
        title: Text(
          termName,
          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
        subtitle:
            Text("Status: $status"),
        trailing:
            IconButton(
          tooltip:
              "Delete term",
          icon: const Icon(
            Icons.delete_outline,
          ),
          onPressed:
              isSaving
                  ? null
                  : () =>
                      _deleteTerm(
                        term,
                      ),
        ),
      ),
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
      appBar: AppBar(
        title:
            const Text("Academic Setup"),
        backgroundColor:
            Colors.amber,
        foregroundColor:
            Colors.black,
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                children: [
                  const Text(
                    "Academic Structure",
                    style:
                        TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(
                    "Configure the academic structure for a selected academic year.",
                    style:
                        TextStyle(
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  _academicYearSelector(),

                  const SizedBox(
                    height: 15,
                  ),

                  _yearInformation(),

                  const SizedBox(
                    height: 30,
                  ),

                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Academic Terms",
                          style:
                              TextStyle(
                            fontSize: 23,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                      ElevatedButton
                          .icon(
                        onPressed:
                            selectedAcademicYearId ==
                                        null ||
                                    isSaving
                                ? null
                                : _addTerm,
                        icon:
                            const Icon(
                          Icons.add,
                        ),
                        label:
                            const Text(
                          "ADD TERM",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  if (selectedAcademicYearId ==
                      null)
                    const Card(
                      child:
                          Padding(
                        padding:
                            EdgeInsets.all(
                          16,
                        ),
                        child: Text(
                          "Create an academic year first.",
                        ),
                      ),
                    )
                  else if (academicTerms
                      .isEmpty)
                    const Card(
                      child:
                          Padding(
                        padding:
                            EdgeInsets.all(
                          16,
                        ),
                        child: Text(
                          "No terms have been configured for this academic year.",
                        ),
                      ),
                    )
                  else
                    ...academicTerms.map(
                      _termCard,
                    ),

                  const SizedBox(
                    height: 35,
                  ),

                  // ------------------------------------------------
                  // FUTURE SECTIONS
                  // ------------------------------------------------

                  const Text(
                    "Class / Grade Setup",
                    style:
                        TextStyle(
                      fontSize: 23,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Card(
                    child:
                        Padding(
                      padding:
                          EdgeInsets.all(
                        16,
                      ),
                      child: Text(
                        "Classes and grades will be configured here next.",
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  const Text(
                    "Section Setup",
                    style:
                        TextStyle(
                      fontSize: 23,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Card(
                    child:
                        Padding(
                      padding:
                          EdgeInsets.all(
                        16,
                      ),
                      child: Text(
                        "Sections will be configured here next.",
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  const Text(
                    "Subject Setup",
                    style:
                        TextStyle(
                      fontSize: 23,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Card(
                    child:
                        Padding(
                      padding:
                          EdgeInsets.all(
                        16,
                      ),
                      child: Text(
                        "Subjects will be configured here next.",
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}