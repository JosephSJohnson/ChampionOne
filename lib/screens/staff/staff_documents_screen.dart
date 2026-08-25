

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:universal_html/html.dart' as html;

import '../../models/staff_model.dart';
import '../../models/staff_document_model.dart';
import '../../database/database_helper.dart';
import '../../utils/file_storage.dart';

class StaffDocumentsScreen extends StatefulWidget {
  final StaffModel staff;

  const StaffDocumentsScreen({
    super.key,
    required this.staff,
  });

  @override
  State<StaffDocumentsScreen> createState() =>
      _StaffDocumentsScreenState();
}

class _StaffDocumentsScreenState
    extends State<StaffDocumentsScreen> {

  String selectedDocumentType = "Degree Certificate";
  String documentFilter = "All Documents";

  Uint8List? selectedFileBytes;

  String selectedFileName = "";
  String uploadDate = "";

  List<StaffDocumentModel> documents = [];

  // ============================================================
  // LOAD DOCUMENTS
  // ============================================================

  Future<void> loadDocuments() async {
    final data =
        await DatabaseHelper.instance.getDocuments(
      widget.staff.staffID,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      documents = data
          .map(
            (item) =>
                StaffDocumentModel.fromMap(item),
          )
          .toList();
    });
  }

  // ============================================================
  // OPEN DOCUMENT
  // ============================================================

  Future<void> openDocument(
  StaffDocumentModel document,
) async {
  try {
    final bytes = await FileStorage.readFile(
      document.filePath,
    );

    if (bytes == null) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to open document. The stored file could not be found.",
          ),
        ),
      );

      return;
    }

    if (kIsWeb) {
      final fileName = document.documentName.toLowerCase();

      String mimeType = 'application/octet-stream';

      if (fileName.endsWith('.pdf')) {
        mimeType = 'application/pdf';
      } else if (fileName.endsWith('.jpg') ||
          fileName.endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      } else if (fileName.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (fileName.endsWith('.gif')) {
        mimeType = 'image/gif';
      } else if (fileName.endsWith('.webp')) {
        mimeType = 'image/webp';
      } else if (fileName.endsWith('.txt')) {
        mimeType = 'text/plain';
      } else if (fileName.endsWith('.doc')) {
        mimeType = 'application/msword';
      } else if (fileName.endsWith('.docx')) {
        mimeType =
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      } else if (fileName.endsWith('.xls')) {
        mimeType = 'application/vnd.ms-excel';
      } else if (fileName.endsWith('.xlsx')) {
        mimeType =
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      }

      final blob = html.Blob(
        [bytes],
        mimeType,
      );

      final url =
          html.Url.createObjectUrlFromBlob(blob);

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

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Document loaded successfully.",
        ),
      ),
    );
  } catch (e) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Could not open document: $e",
        ),
      ),
    );
  }
}

  // ============================================================
  // PICK DOCUMENT
  // ============================================================

  Future<void> pickDocument() async {
    final result =
        await FilePicker.platform.pickFiles(
      withData: true,
    );

    if (result == null) {
      return;
    }

    final pickedFile =
        result.files.single;

    if (pickedFile.bytes == null) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to read the selected document.",
          ),
        ),
      );

      return;
    }

    setState(() {
      selectedFileBytes =
          pickedFile.bytes;

      selectedFileName =
          pickedFile.name;

      uploadDate =
          DateTime.now().toIso8601String();
    });
  }

  // ============================================================
  // ADD DOCUMENT
  // ============================================================

  Future<void> addDocument() async {
    if (selectedFileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please choose a document first.",
          ),
        ),
      );

      return;
    }

    try {
      final documentBytes =
          selectedFileBytes!;

      final savedPath =
          await FileStorage.saveStaffDocument(
        documentBytes,
        fileName: selectedFileName,
      );

      final document =
          StaffDocumentModel(
        staffID: widget.staff.staffID,
        documentType:
            selectedDocumentType,
        documentName:
            selectedFileName,
        filePath: savedPath,
        uploadDate: uploadDate,
      );

      await DatabaseHelper.instance
          .insertDocument(
        document.toMap(),
      );

      await loadDocuments();

      if (!mounted) {
        return;
      }

      setState(() {
        selectedFileBytes = null;
        selectedFileName = "";
        uploadDate = "";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Document saved successfully.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to save document: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // DELETE DOCUMENT
  // ============================================================

  Future<void> deleteDocument(
    StaffDocumentModel document,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete Document",
          ),
          content: Text(
            "Are you sure you want to delete "
            "\"${document.documentName}\"?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                "CANCEL",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                "DELETE",
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await DatabaseHelper.instance
        .deleteDocument(
      document.id!,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      documents.removeWhere(
        (item) =>
            item.id == document.id,
      );
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Document deleted successfully.",
        ),
      ),
    );
  }

  // ============================================================
  // DOCUMENT DETAILS
  // ============================================================

  void showDocumentDetails(
    StaffDocumentModel document,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Document Details",
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                "Document Name",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Text(
                document.documentName,
              ),

              const SizedBox(
                height: 12,
              ),

              const Text(
                "Document Type",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Text(
                document.documentType,
              ),

              const SizedBox(
                height: 12,
              ),

              const Text(
                "Upload Date",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Text(
                document.uploadDate,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Text(
                "CLOSE",
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(
                  context,
                );

                openDocument(
                  document,
                );
              },
              icon: const Icon(
                Icons.open_in_new,
              ),
              label: const Text(
                "OPEN",
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // INITIALIZE
  // ============================================================

  @override
  void initState() {
    super.initState();

    loadDocuments();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final filteredDocuments =
        documentFilter ==
                "All Documents"
            ? documents
            : documents
                .where(
                  (document) =>
                      document.documentType ==
                      documentFilter,
                )
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.staff.fullName} Documents",
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
                "${documents.length} Documents",
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

      body: Column(
        children: [
          // ======================================================
          // DOCUMENT TYPE
          // ======================================================

          Padding(
            padding:
                const EdgeInsets.all(
              20,
            ),
            child:
                DropdownButtonFormField<
                    String>(
              initialValue:
                  selectedDocumentType,

              decoration:
                  const InputDecoration(
                labelText:
                    "Document Type",
                border:
                    OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(
                  value:
                      "Degree Certificate",
                  child: Text(
                    "Degree Certificate",
                  ),
                ),

                DropdownMenuItem(
                  value:
                      "Teaching License",
                  child: Text(
                    "Teaching License",
                  ),
                ),

                DropdownMenuItem(
                  value:
                      "Resume/CV",
                  child: Text(
                    "Resume/CV",
                  ),
                ),

                DropdownMenuItem(
                  value:
                      "Training Certificate",
                  child: Text(
                    "Training Certificate",
                  ),
                ),

                DropdownMenuItem(
                  value:
                      "ID Document",
                  child: Text(
                    "ID Document",
                  ),
                ),

                DropdownMenuItem(
                  value: "Other",
                  child: Text(
                    "Other",
                  ),
                ),
              ],

              onChanged:
                  (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedDocumentType =
                      value;
                });
              },
            ),
          ),

          // ======================================================
          // CHOOSE DOCUMENT
          // ======================================================

          SizedBox(
            width:
                double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 20,
              ),
              child:
                  ElevatedButton.icon(
                onPressed:
                    pickDocument,

                icon: const Icon(
                  Icons.attach_file,
                ),

                label: const Text(
                  "CHOOSE DOCUMENT",
                ),

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.blue,
                  foregroundColor:
                      Colors.white,
                ),
              ),
            ),
          ),

          // ======================================================
          // SELECTED FILE
          // ======================================================

          if (selectedFileBytes !=
                  null &&
              selectedFileName
                  .isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets
                        .all(12),
                decoration:
                    BoxDecoration(
                  border:
                      Border.all(
                    color:
                        Colors.blue,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    8,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons
                          .description,
                      color:
                          Colors.blue,
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child: Text(
                        "Selected File: "
                        "$selectedFileName",
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(
            height: 10,
          ),

          // ======================================================
          // ADD DOCUMENT
          // ======================================================

          SizedBox(
            width:
                double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 20,
              ),
              child:
                  ElevatedButton.icon(
                onPressed:
                    addDocument,

                icon: const Icon(
                  Icons.upload_file,
                ),

                label: const Text(
                  "ADD DOCUMENT",
                ),

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.amber,
                  foregroundColor:
                      Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          // ======================================================
          // DOCUMENT FILTER
          // ======================================================

          Padding(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child:
                DropdownButtonFormField<
                    String>(
              initialValue:
                  documentFilter,

              decoration:
                  const InputDecoration(
                labelText:
                    "Filter Documents",
                border:
                    OutlineInputBorder(),
                prefixIcon:
                    Icon(
                  Icons.filter_list,
                ),
              ),

              items: const [
                DropdownMenuItem(
                  value:
                      "All Documents",
                  child: Text(
                    "All Documents",
                  ),
                ),

                DropdownMenuItem(
                  value:
                      "Degree Certificate",
                  child: Text(
                    "Degree Certificate",
                  ),
                ),

                DropdownMenuItem(
                  value:
                      "Teaching License",
                  child: Text(
                    "Teaching License",
                  ),
                ),

                DropdownMenuItem(
                  value:
                      "Resume/CV",
                  child: Text(
                    "Resume/CV",
                  ),
                ),

                DropdownMenuItem(
                  value:
                      "Training Certificate",
                  child: Text(
                    "Training Certificate",
                  ),
                ),

                DropdownMenuItem(
                  value:
                      "ID Document",
                  child: Text(
                    "ID Document",
                  ),
                ),

                DropdownMenuItem(
                  value: "Other",
                  child: Text(
                    "Other",
                  ),
                ),
              ],

              onChanged:
                  (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  documentFilter =
                      value;
                });
              },
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // ======================================================
          // DOCUMENT LIST
          // ======================================================

          Expanded(
            child:
                filteredDocuments.isEmpty
                    ? Center(
                        child:
                            Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          children: const [
                            Icon(
                              Icons
                                  .description_outlined,
                              size: 64,
                              color:
                                  Colors.grey,
                            ),

                            SizedBox(
                              height: 12,
                            ),

                            Text(
                              "No Documents Found",
                              style:
                                  TextStyle(
                                fontSize:
                                    20,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            SizedBox(
                              height: 8,
                            ),

                            Text(
                              "This staff member has no documents\n"
                              "uploaded yet.",
                              textAlign:
                                  TextAlign
                                      .center,
                              style:
                                  TextStyle(
                                color:
                                    Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            filteredDocuments
                                .length,

                        itemBuilder:
                            (
                          context,
                          index,
                        ) {
                          final document =
                              filteredDocuments[
                                  index];

                          return Card(
                            margin:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  20,
                              vertical:
                                  6,
                            ),

                            child:
                                ListTile(
                              onTap: () {
                                showDocumentDetails(
                                  document,
                                );
                              },

                              leading:
                                  const Icon(
                                Icons
                                    .description,
                                color:
                                    Colors.blue,
                              ),

                              title:
                                  Text(
                                document
                                    .documentName,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              subtitle:
                                  Text(
                                "${document.documentType}\n"
                                "${document.uploadDate}\n"
                                "File available",
                              ),

                              trailing:
                                  Row(
                                mainAxisSize:
                                    MainAxisSize
                                        .min,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(
                                      Icons
                                          .open_in_new,
                                      color:
                                          Colors.green,
                                    ),
                                    tooltip:
                                        "Open Document",
                                    onPressed:
                                        () {
                                      openDocument(
                                        document,
                                      );
                                    },
                                  ),

                                  IconButton(
                                    icon:
                                        const Icon(
                                      Icons
                                          .delete,
                                      color:
                                          Colors.red,
                                    ),
                                    tooltip:
                                        "Delete Document",
                                    onPressed:
                                        () {
                                      deleteDocument(
                                        document,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // ======================================================
          // FOOTER
          // ======================================================

          const Padding(
            padding:
                EdgeInsets.only(
              bottom: 20,
            ),
            child: Text(
              "Staff Documents",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}