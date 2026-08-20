import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';

import '../../models/staff_model.dart';
import '../../models/staff_document_model.dart';
import '../../database/database_helper.dart';


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

  File? selectedFile;

String selectedFileName = "";
String uploadDate = "";
List<StaffDocumentModel> documents = [];

Future<void> loadDocuments() async {

  final data =
      await DatabaseHelper.instance.getDocuments(
    widget.staff.staffID,
  );

  setState(() {

    documents = data
        .map(
          (item) =>
              StaffDocumentModel.fromMap(item),
        )
        .toList();

  });

}

Future<void> openDocument(
  StaffDocumentModel document,
) async {

  final result =
      await OpenFilex.open(
    document.filePath,
  );

  if (result.type != ResultType.done) {

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(
        content: Text(
          "Could not open document: ${result.message}",
        ),
      ),

    );

  }

}

StaffDocumentModel createDocumentModel() {

  return StaffDocumentModel(

    staffID: widget.staff.staffID,

    documentType: selectedDocumentType,

    documentName: selectedFileName,

    filePath: selectedFile!.path,

    uploadDate: uploadDate,

  );

}

Future<void> pickDocument() async {

  FilePickerResult? result =
      await FilePicker.platform.pickFiles();

  if (result != null) {

    setState(() {

  selectedFile =
      File(result.files.single.path!);

  selectedFileName =
      result.files.single.name;

      uploadDate =
    DateTime.now().toIso8601String();

});

  }

}

Future<void> deleteDocument(
  StaffDocumentModel document,
) async {

  final confirmed = await showDialog<bool>(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
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

final file = File(document.filePath);

final fileExists = await file.exists();

if (fileExists) {
  await file.delete();
}

await DatabaseHelper.instance.deleteDocument(
  document.id!,
);
  if (!mounted) {
    return;
  }

  setState(() {

    documents.removeWhere(
      (item) => item.id == document.id,
    );

  });

  ScaffoldMessenger.of(context).showSnackBar(

    const SnackBar(
      content: Text(
        "Document deleted successfully.",
      ),
    ),

  );

}

@override
void initState() {
  super.initState();

  loadDocuments();
}

@override
Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(
          "${widget.staff.fullName} Documents",
        ),

        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,

      ),



     body: Column(

  children: [

    Padding(
  padding: const EdgeInsets.all(20),

  child: DropdownButtonFormField<String>(

    value: selectedDocumentType,

    decoration: const InputDecoration(
      labelText: "Document Type",
      border: OutlineInputBorder(),
    ),

    items: const [

      DropdownMenuItem(
        value: "Degree Certificate",
        child: Text(
          "Degree Certificate",
        ),
      ),

      DropdownMenuItem(
        value: "Teaching License",
        child: Text(
          "Teaching License",
        ),
      ),

      DropdownMenuItem(
        value: "Resume/CV",
        child: Text(
          "Resume/CV",
        ),
      ),

      DropdownMenuItem(
        value: "Training Certificate",
        child: Text(
          "Training Certificate",
        ),
      ),

      DropdownMenuItem(
        value: "ID Document",
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

    onChanged: (value) {

      setState(() {

        selectedDocumentType = value!;

      });

    },

  ),

),

SizedBox(
  width: double.infinity,
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    child: ElevatedButton.icon(
      onPressed: () {
        pickDocument();
      },
      icon: const Icon(
        Icons.attach_file,
      ),
      label: const Text(
        "CHOOSE DOCUMENT",
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
  ),
),
    const SizedBox(
      height: 20,
    ),


    SizedBox(

      width: double.infinity,

      child: Padding(

        padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),

        child: ElevatedButton.icon(

          onPressed: () async {

  if (selectedFile == null) {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content: Text(
          "Please choose a document first.",
        ),
      ),

    );

    return;

  }

  StaffDocumentModel document =
      createDocumentModel();

  await DatabaseHelper.instance.insertDocument(
    document.toMap(),
  );

  ScaffoldMessenger.of(context).showSnackBar(

    const SnackBar(
      content: Text(
        "Document saved successfully.",
      ),
    ),

  );

},
          icon: const Icon(
            Icons.upload_file,
          ),

          label: const Text(
            "ADD DOCUMENT",
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

    ),

    if (documents.isNotEmpty)
  Expanded(
    child: ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {

        final document = documents[index];

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 6,
          ),

          child: ListTile(

            leading: const Icon(
              Icons.description,
              color: Colors.blue,
            ),

            title: Text(
              document.documentName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Text(
              "${document.documentType}\n"
              "${document.uploadDate}",
            ),

            trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [

    IconButton(
      icon: const Icon(
        Icons.open_in_new,
        color: Colors.green,
      ),

      tooltip: "Open Document",

      onPressed: () {
        openDocument(document);
      },
    ),

    IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),

      tooltip: "Delete Document",

      onPressed: () {
        deleteDocument(document);
      },
    ),

  ],
),

          ),
        );

      },
    ),
  ),

    if (selectedFile != null)
  Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    child: Text(
      "Selected File: ${selectedFile!.path.split('\\').last}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ),


    const SizedBox(
      height: 30,
    ),


    const Text(
      "Staff Documents",
      style: TextStyle(
        fontSize: 20,
        fontWeight:
            FontWeight.bold,
      ),
    ),

  ],

),

    );

  }

}