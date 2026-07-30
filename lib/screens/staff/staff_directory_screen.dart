import 'package:flutter/material.dart';

import '../../data/staff_data.dart';
import 'staff_profile_screen.dart';


class StaffDirectoryScreen extends StatefulWidget {

  const StaffDirectoryScreen({super.key});

  @override
  State<StaffDirectoryScreen> createState() =>
      _StaffDirectoryScreenState();

}



class _StaffDirectoryScreenState
    extends State<StaffDirectoryScreen> {


  final TextEditingController searchController =
      TextEditingController();


  String searchText = "";



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


      return staff.fullName
              .toLowerCase()
              .contains(search) ||

          staff.staffID
              .toLowerCase()
              .contains(search) ||

          staff.role
              .toLowerCase()
              .contains(search);


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



                                    CircleAvatar(

                                      radius: 30,


                                      backgroundImage:
                                          staff.profileImage.isNotEmpty

                                              ? NetworkImage(
                                                  staff.profileImage,
                                                )

                                              : null,


                                      child:
                                          staff.profileImage.isEmpty

                                              ? Text(

                                                  staff.fullName[0]
                                                      .toUpperCase(),


                                                  style:
                                                      const TextStyle(

                                                    fontSize:
                                                        22,

                                                    fontWeight:
                                                        FontWeight.bold,

                                                  ),

                                                )

                                              : null,

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

                                        staff.accountStatus ==
                                                "Active"

                                            ? Colors.green

                                            : staff.accountStatus ==
                                                    "Pending"

                                                ? Colors.orange

                                                : Colors.red,


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