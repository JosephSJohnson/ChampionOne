import 'package:flutter/material.dart';
import '../staff/staff_management_screen.dart';

class ProprietorDashboardScreen extends StatelessWidget {

  final String proprietorName;

  const ProprietorDashboardScreen({
    super.key,
    required this.proprietorName,
  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Proprietor Dashboard",
        ),

        backgroundColor: Colors.amber,

        foregroundColor: Colors.black,

      ),


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            Text(

              "Welcome, $proprietorName",

              style: const TextStyle(

                fontSize: 24,

                fontWeight: FontWeight.bold,

              ),

            ),


            const SizedBox(height: 8),


            const Text(

              "ChampionOne School Management System",

              style: TextStyle(

                fontSize: 16,

              ),

            ),


            const SizedBox(height: 30),


            GridView.count(

              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: 2,

              crossAxisSpacing: 15,

              mainAxisSpacing: 15,


              children: [

_dashboardCard(
  icon: Icons.school,
  title: "School Overview",
  onTap: () {},
),



                _dashboardCard(
  icon: Icons.people,
  title: "Staff Management",
  onTap: () {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StaffManagementScreen(),
      ),
    );

  },
),


                _dashboardCard(
                  icon: Icons.person,
                  title: "Student Management",
                  onTap: () {},
                ),


                _dashboardCard(
                  icon: Icons.menu_book,
                  title: "Academics",
                  onTap: () {},
                ),


                _dashboardCard(
                  icon: Icons.attach_money,
                  title: "Finance",
                  onTap: () {},
                ),


                _dashboardCard(
                  icon: Icons.bar_chart,
                  title: "Reports",
                  onTap: () {},
                ),


                _dashboardCard(
                  icon: Icons.settings,
                  title: "Settings",
                  onTap: () {},
                ),


              ],

            ),

          ],

        ),

      ),

    );

  }



  Widget _dashboardCard({

  required IconData icon,

  required String title,

  required VoidCallback onTap,

})
 {

    return Card(

      elevation: 3,

      child: InkWell(

  onTap: onTap,

  child: Padding(

          padding: const EdgeInsets.all(20),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,


            children: [


              Icon(

                icon,

                size: 40,

              ),


              const SizedBox(height: 15),


              Text(

                title,

                textAlign: TextAlign.center,

                style: const TextStyle(

                  fontSize: 16,

                  fontWeight: FontWeight.bold,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}