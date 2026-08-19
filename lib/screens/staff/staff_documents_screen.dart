import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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