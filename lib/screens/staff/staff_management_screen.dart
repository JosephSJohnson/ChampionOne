import 'package:flutter/material.dart';
import 'create_staff_screen.dart';
import 'staff_directory_screen.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Staff Management",
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            const Text(
              "Manage School Staff",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 10),


            const Text(
              "Create and manage leadership and teaching staff accounts.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),


            const SizedBox(height: 30),


            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton.icon(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),


                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CreateStaffScreen(),
                    ),
                  );

                },


                icon: const Icon(
                  Icons.person_add,
                ),


                label: const Text(
                  "CREATE STAFF ACCOUNT",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),

            ),


            const SizedBox(height: 30),

SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StaffDirectoryScreen(),
        ),
      );
    },
    icon: const Icon(Icons.people),
    label: const Text(
      "VIEW STAFF DIRECTORY",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

const SizedBox(height: 20),
            const Text(
              "Staff Categories",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 15),


            _staffCard(
              Icons.admin_panel_settings,
              "Principal",
            ),


            _staffCard(
              Icons.school,
              "Vice Principal Academic Affairs",
            ),


            _staffCard(
              Icons.people,
              "Vice Principal Student Affairs",
            ),


            _staffCard(
              Icons.menu_book,
              "Teachers",
            ),


          ],

        ),

      ),

    );

  }



  Widget _staffCard(
      IconData icon,
      String title,
      ) {

    return Card(

      elevation: 3,

      child: ListTile(

        leading: Icon(
          icon,
          size: 35,
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
        ),

      ),

    );

  }

}