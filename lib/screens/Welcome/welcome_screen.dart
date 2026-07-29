import 'package:flutter/material.dart';
import '../setup/school_setup_screen.dart';


class WelcomeScreen extends StatelessWidget {

  const WelcomeScreen({super.key});



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.school,
              size: 100,
              color: Colors.amber,
            ),


            const SizedBox(height: 25),


            const Text(
              "Welcome to ChampionOne",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 15),


            const Text(
              "School Management System\nDeveloped by Champion's Foundation",
              textAlign: TextAlign.center,
            ),


            const SizedBox(height: 40),


            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),


              onPressed: () {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const SchoolSetupScreen(),
    ),
  );

},


              child: const Text(
                "GET STARTED",
              ),

            ),

          ],
        ),
      ),
    );
  }
}