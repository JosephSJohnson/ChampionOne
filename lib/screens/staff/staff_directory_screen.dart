import 'package:flutter/material.dart';
import '../../data/staff_data.dart';
import 'staff_profile_screen.dart';


class StaffDirectoryScreen extends StatefulWidget {

  const StaffDirectoryScreen({super.key});

  @override
  State<StaffDirectoryScreen> createState() =>
      _StaffDirectoryScreenState();

}


class _StaffDirectoryScreenState extends State<StaffDirectoryScreen> {



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Staff Directory",
        ),

        backgroundColor: Colors.amber,

        foregroundColor: Colors.black,

      ),



      body: StaffData.staffList.isEmpty

          ? const Center(

              child: Text(

                "No Staff Account Found",

                style: TextStyle(

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                ),

              ),

            )



          : ListView.builder(

              padding: const EdgeInsets.all(15),


              itemCount: StaffData.staffList.length,


              itemBuilder: (context, index) {


                final staff = StaffData.staffList[index];


                return InkWell(

  onTap: () {

    Navigator.push(

  context,

  MaterialPageRoute(

    builder: (context) => StaffProfileScreen(
      staff: staff,
    ),

  ),

).then((value) {

  setState(() {});

});

  },

  child: Card(

    elevation: 4,

    margin: const EdgeInsets.only(
      bottom: 15,
    ),

    child: Padding(

                    padding: const EdgeInsets.all(15),


                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,


                      children: [



                        Row(

                          children: [


                            CircleAvatar(
  radius: 28,

  backgroundImage: staff.profileImage.isNotEmpty
      ? NetworkImage(staff.profileImage)
      : null,

  child: staff.profileImage.isEmpty
      ? Text(
          staff.fullName[0].toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        )
      : null,
),

                            const SizedBox(width: 15),



                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment.start,


                                children: [


                                  Text(

                                    staff.fullName,

                                    style:
                                        const TextStyle(

                                      fontSize: 20,

                                      fontWeight:
                                          FontWeight.bold,

                                    ),

                                  ),



                                  Text(

                                    "Staff ID: ${staff.staffID}",

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

                          "Gender: ${staff.gender}",

                        ),



                        Text(

                          "Date of Birth: ${staff.dateOfBirth}",

                        ),



                        Text(

                          "Nationality: ${staff.nationality}",

                        ),



                        Text(

                          "Qualification: ${staff.qualification}",

                        ),



                        Text(

                          "Other Qualification(s): ${staff.otherQualification}",

                        ),



                        Text(

                          "Phone: ${staff.phone}",

                        ),



                        Text(

                          "Email: ${staff.email}",

                        ),



                        const SizedBox(height: 10),



                        Container(

                          padding:
                              const EdgeInsets.symmetric(

                            horizontal: 12,

                            vertical: 6,

                          ),


                          decoration: BoxDecoration(

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

                            style: const TextStyle(

                              color: Colors.white,

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

    );

  }

}