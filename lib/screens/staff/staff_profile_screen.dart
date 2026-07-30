import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:html' as html;

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
  State<StaffProfileScreen> createState() =>
      _StaffProfileScreenState();

}



class _StaffProfileScreenState extends State<StaffProfileScreen> {


  late StaffModel staff;



  @override
  void initState() {

    super.initState();

    staff = widget.staff;

  }



  void refreshStaff() {

    final updatedStaff = StaffData.getStaffByID(
      staff.staffID,
    );


    if (updatedStaff != null) {

      staff = updatedStaff;

    }

  }



  @override
  Widget build(BuildContext context) {


    refreshStaff();


    print("PROFILE IMAGE PATH: ${staff.profileImage}");


    return Scaffold(


      appBar: AppBar(

        title: const Text(
          "Staff Profile",
        ),

        backgroundColor: Colors.amber,

        foregroundColor: Colors.black,


        actions: [


          IconButton(

            icon: const Icon(
              Icons.edit,
            ),


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



            Card(

  child: Padding(

    padding: const EdgeInsets.all(15),

    child: Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

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

              style: TextStyle(

                fontSize: 16,

                fontWeight:
                    FontWeight.bold,

              ),

            ),

          ],

        ),



        const SizedBox(
          height: 10,
        ),



        Text(

          staff.qualificationDocument.isEmpty

              ? "No document uploaded"

              : staff.qualificationDocument
                  .split('/')
                  .last,

        ),



        const SizedBox(
          height: 15,
        ),



        if (staff.qualificationDocument.isNotEmpty)

          SizedBox(

            width: double.infinity,

            child: ElevatedButton.icon(

            onPressed: () {

  if (staff.qualificationDocument.isNotEmpty) {

    html.window.open(

      staff.qualificationDocument,

      "_blank",

    );

  }

},


              icon: const Icon(
                Icons.open_in_new,
              ),


              label: const Text(

                "VIEW CERTIFICATE",

              ),

            ),

          ),


      ],

    ),

  ),

),


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


            _buildInfo(
              "Account Status",
              staff.accountStatus,
            ),



          ],

        ),

      ),

    );

  }




  Widget _buildInfo(
    String title,
    String value,
  ) {


    return Card(

      margin: const EdgeInsets.only(
        bottom: 12,
      ),


      child: ListTile(

        title: Text(

          title,

          style: const TextStyle(

            fontWeight: FontWeight.bold,

          ),

        ),


        subtitle: Text(

          value.isEmpty
          ? "-"
          : value,

        ),

      ),

    );

  }


}