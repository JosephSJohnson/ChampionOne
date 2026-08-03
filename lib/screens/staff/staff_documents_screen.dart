import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/staff_model.dart';


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

          onPressed: () {

  ScaffoldMessenger.of(context).showSnackBar(

    const SnackBar(

      content: Text(
        "Add Document feature coming next",
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