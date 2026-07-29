import 'package:flutter/material.dart';
import '../dashboard/proprietor_dashboard_screen.dart';

class InstitutionHeadSetupScreen extends StatefulWidget {

  final String roleTitle;

  const InstitutionHeadSetupScreen({
    super.key,
    required this.roleTitle,
  });

  @override
  State<InstitutionHeadSetupScreen> createState() =>
      _InstitutionHeadSetupScreenState();
}


class _InstitutionHeadSetupScreenState
    extends State<InstitutionHeadSetupScreen> {


  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();
      final TextEditingController usernameController =
    TextEditingController();

final TextEditingController passwordController =
    TextEditingController();

final TextEditingController confirmPasswordController =
    TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(
          "Create ${widget.roleTitle} Account",
        ),

        backgroundColor: Colors.amber,

        foregroundColor: Colors.black,

      ),


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [


            Text(

              "Institution Head Information",

              style: const TextStyle(

                fontSize: 22,

                fontWeight: FontWeight.bold,

              ),

            ),


            const SizedBox(height: 10),


            Text(

              "Create account for the ${widget.roleTitle}.",

              style: const TextStyle(

                fontSize: 16,

              ),

            ),
            const SizedBox(height: 15),

Container(

  width: double.infinity,

  padding: const EdgeInsets.all(15),

  decoration: BoxDecoration(

    border: Border.all(
      color: Colors.amber,
    ),

    borderRadius: BorderRadius.circular(10),

  ),

  child: Text(

    "Account Role: ${widget.roleTitle}",

    style: const TextStyle(

      fontSize: 17,

      fontWeight: FontWeight.bold,

    ),

  ),

),


            const SizedBox(height: 30),



            TextField(

              controller: nameController,

              decoration: const InputDecoration(

                labelText: "Full Name",

                border: OutlineInputBorder(),

              ),

            ),
            const SizedBox(height: 20),

TextField(

  controller: usernameController,

  decoration: const InputDecoration(

    labelText: "Username",

    border: OutlineInputBorder(),

  ),

),

const SizedBox(height: 20),

TextField(

  controller: passwordController,

  obscureText: true,

  decoration: const InputDecoration(

    labelText: "Password",

    border: OutlineInputBorder(),

  ),

),

const SizedBox(height: 20),

TextField(

  controller: confirmPasswordController,

  obscureText: true,

  decoration: const InputDecoration(

    labelText: "Confirm Password",

    border: OutlineInputBorder(),

  ),

),


            const SizedBox(height: 20),



            TextField(

              controller: phoneController,

              decoration: const InputDecoration(

                labelText: "Phone Number",

                border: OutlineInputBorder(),

              ),

            ),


            const SizedBox(height: 20),



            TextField(

              controller: emailController,

              decoration: const InputDecoration(

                labelText: "Email Address",

                border: OutlineInputBorder(),

              ),

            ),


            const SizedBox(height: 30),



            SizedBox(

              width: double.infinity,

              height: 55,


              child: ElevatedButton(

                style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.amber,

                  foregroundColor: Colors.black,

                ),


                onPressed: () {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          ProprietorDashboardScreen(
            proprietorName: nameController.text,
          ),
    ),
  );

},

                child: const Text(

                  "CREATE ACCOUNT",

                  style: TextStyle(

                    fontSize: 17,

                    fontWeight: FontWeight.bold,

                  ),

                ),

              ),

            ),


          ],

        ),

      ),

    );

  }

}