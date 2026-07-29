import 'package:flutter/material.dart';


class AdminSetupScreen extends StatefulWidget {

  const AdminSetupScreen({super.key});


  @override
  State<AdminSetupScreen> createState() =>
      _AdminSetupScreenState();

}


class _AdminSetupScreenState extends State<AdminSetupScreen> {


  final fullNameController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Administrator Setup",
        ),

        backgroundColor: Colors.amber,

      ),



      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),


        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,


          children: [


            const Text(

              "Create School Administrator",

              style: TextStyle(

                fontSize: 26,

                fontWeight: FontWeight.bold,

              ),

            ),



            const SizedBox(height: 10),



            const Text(

              "This account will manage your ChampionOne school system.",

            ),



            const SizedBox(height: 25),



            TextField(

              controller: fullNameController,

              decoration: const InputDecoration(

                labelText: "Full Name",

                border: OutlineInputBorder(),

              ),

            ),



            const SizedBox(height: 15),



            TextField(

              controller: phoneController,

              keyboardType: TextInputType.phone,

              decoration: const InputDecoration(

                labelText: "Phone Number",

                border: OutlineInputBorder(),

              ),

            ),



            const SizedBox(height: 15),



            TextField(

              controller: emailController,

              keyboardType: TextInputType.emailAddress,

              decoration: const InputDecoration(

                labelText: "Email Address",

                border: OutlineInputBorder(),

              ),

            ),



            const SizedBox(height: 20),



            const Text(

              "Login Information",

              style: TextStyle(

                fontSize: 20,

                fontWeight: FontWeight.bold,

              ),

            ),



            const SizedBox(height: 15),



            TextField(

              controller: usernameController,

              decoration: const InputDecoration(

                labelText: "Username",

                border: OutlineInputBorder(),

              ),

            ),



            const SizedBox(height: 15),



            TextField(

              controller: passwordController,

              obscureText: true,

              decoration: const InputDecoration(

                labelText: "Password",

                border: OutlineInputBorder(),

              ),

            ),



            const SizedBox(height: 15),



            TextField(

              controller: confirmPasswordController,

              obscureText: true,

              decoration: const InputDecoration(

                labelText: "Confirm Password",

                border: OutlineInputBorder(),

              ),

            ),



            const SizedBox(height: 20),



            Container(

              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(

                border: Border.all(),

                borderRadius: BorderRadius.circular(10),

              ),


              child: const Row(

                children: [

                  Icon(Icons.admin_panel_settings),

                  SizedBox(width: 10),

                  Expanded(

                    child: Text(

                      "Account Role: School Administrator",

                    ),

                  ),

                ],

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


                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    const SnackBar(

                      content: Text(

                        "Administrator account created successfully",

                      ),

                    ),

                  );


                },


                child: const Text(

                  "CREATE ADMIN ACCOUNT",

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