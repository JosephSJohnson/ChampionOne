import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../data/staff_data.dart';
import '../../utils/file_storage.dart';
import 'staff_profile_screen.dart';


class StaffDirectoryScreen extends StatefulWidget {

  const StaffDirectoryScreen({super.key});

  @override
  State<StaffDirectoryScreen> createState() =>
      _StaffDirectoryScreenState();

}



class _StaffDirectoryScreenState
    extends State<StaffDirectoryScreen> {

  Future<Uint8List?> _loadStaffPhoto(
    String imagePath,
  ) async {
    if (imagePath.isEmpty) {
      return null;
    }

    return FileStorage.readFile(imagePath);
  }

  final TextEditingController searchController =
      TextEditingController();


  String searchText = "";

  String selectedRole = "All Roles";


final List<String> roles = [

  "All Roles",
  "Principal",
  "Vice Principal Academic Affairs",
  "Vice Principal Student Affairs",
  "Finance Officer",
  "Secretary",
  "Teacher",
  "Class Teacher",
  "Librarian",
  "Other Staff",

];

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  StaffData.loadStaff().then((_) {

    setState(() {});

  });

}


  @override
  void dispose() {

    searchController.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context) {


   final filteredStaff =
    StaffData.staffList.where((staff) {


  final search =
      searchText.toLowerCase();


  final matchesSearch =

      staff.fullName
              .toLowerCase()
              .contains(search) ||

          staff.staffID
              .toLowerCase()
              .contains(search) ||

          staff.role
              .toLowerCase()
              .contains(search);



  final matchesRole =

      selectedRole == "All Roles"

          ? true

          : staff.role == selectedRole;



  return matchesSearch && matchesRole;


}).toList();

    return Scaffold(


      appBar: AppBar(

        title: const Text(
          "Staff Directory",
        ),

        backgroundColor: Colors.amber,

        foregroundColor: Colors.black,

      ),



      body: Column(

        children: [


          Padding(

            padding:
                const EdgeInsets.all(15),

            child: TextField(

              controller: searchController,


              decoration:
                  const InputDecoration(

                labelText:
                    "Search Staff",

                hintText:
                    "Name, Staff ID or Role",

                prefixIcon:
                    Icon(Icons.search),

                border:
                    OutlineInputBorder(),

              ),


              onChanged: (value) {


                setState(() {

                  searchText = value;

                });


              },


            ),

          ),

          Padding(

  padding: const EdgeInsets.symmetric(
    horizontal: 15,
  ),

  child: DropdownButtonFormField<String>(
     initialValue: selectedRole,

    decoration: const InputDecoration(

      labelText: "Filter By Role",

      border: OutlineInputBorder(),

    ),


    items: roles.map((role) {

      return DropdownMenuItem(

        value: role,

        child: Text(role),

      );

    }).toList(),


    onChanged: (value) {

      setState(() {

        selectedRole = value!;

      });

    },

  ),

),



          Expanded(


            child: filteredStaff.isEmpty


                ? const Center(

                    child: Text(

                      "No Staff Account Found",

                      style:
                          TextStyle(

                        fontSize: 20,

                        fontWeight:
                            FontWeight.bold,

                      ),

                    ),

                  )



                : ListView.builder(


                    padding:
                        const EdgeInsets.all(15),


                    itemCount:
                        filteredStaff.length,


                    itemBuilder:
                        (context, index) {


                      final staff =
                          filteredStaff[index];



                      return Card(


                        elevation: 4,


                        margin:
                            const EdgeInsets.only(

                          bottom: 15,

                        ),



                        child: InkWell(


                          onTap: () async {


                            await Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (context) =>
                                    StaffProfileScreen(

                                  staff: staff,

                                ),

                              ),

                            );


                            setState(() {});


                          },



                          child: Padding(


                            padding:
                                const EdgeInsets.all(15),



                            child: Column(


                              crossAxisAlignment:
                                  CrossAxisAlignment.start,


                              children: [



                                Row(


                                  children: [



                                 FutureBuilder<Uint8List?>(
  future: _loadStaffPhoto(
    staff.profileImage,
  ),
  builder: (context, snapshot) {
    final imageBytes = snapshot.data;

    return CircleAvatar(
      radius: 30,
      backgroundImage: imageBytes != null
          ? MemoryImage(imageBytes)
          : null,
      child: imageBytes == null
          ? Text(
              staff.fullName.isNotEmpty
                  ? staff.fullName[0].toUpperCase()
                  : "?",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  },
),



                                    const SizedBox(
                                      width: 15,
                                    ),



                                    Expanded(

                                      child: Column(

                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,


                                        children: [


                                          Text(

                                            staff.fullName,

                                            style:
                                                const TextStyle(

                                              fontSize:
                                                  20,

                                              fontWeight:
                                                  FontWeight.bold,

                                            ),

                                          ),



                                          Text(

                                            "ID: ${staff.staffID}",

                                          ),



                                          Text(

                                            "Role: ${staff.role}",

                                          ),


                                        ],

                                      ),

                                    ),



                                  ],

                                ),



                                const Divider(),



                                Text(
                                  "Phone: ${staff.phone}",
                                ),


                                Text(
                                  "Email: ${staff.email}",
                                ),



                                const SizedBox(
                                  height: 10,
                                ),



                                Container(

                                  padding:
                                      const EdgeInsets.symmetric(

                                    horizontal: 12,

                                    vertical: 6,

                                  ),


                                  decoration:
                                      BoxDecoration(

                                   color:

    staff.accountStatus == "Active"

        ? Colors.green

        : staff.accountStatus == "Pending"

            ? Colors.orange

            : staff.accountStatus == "Suspended"

                ? Colors.red

                : staff.accountStatus == "Terminated"

                    ? Colors.black

                    : staff.accountStatus == "Resigned"

                        ? Colors.blue

                        : Colors.grey,


                                    borderRadius:
                                        BorderRadius.circular(20),

                                  ),


                                  child: Text(

                                    staff.accountStatus,


                                    style:
                                        const TextStyle(

                                      color:
                                          Colors.white,

                                      fontWeight:
                                          FontWeight.bold,

                                    ),

                                  ),

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


    );

  }


}