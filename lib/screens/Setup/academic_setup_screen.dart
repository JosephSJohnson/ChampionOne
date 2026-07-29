import 'package:flutter/material.dart';


class AcademicSetupScreen extends StatefulWidget {
  const AcademicSetupScreen({super.key});

  @override
  State<AcademicSetupScreen> createState() => _AcademicSetupScreenState();
}


class _AcademicSetupScreenState extends State<AcademicSetupScreen> {

  final academicYearController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  String terms = "Select Number of Terms";


  Future<void> pickStartDate() async {

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        startDate = date;
      });
    }

  }


  Future<void> pickEndDate() async {

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        endDate = date;
      });
    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Academic Setup"),
        backgroundColor: Colors.amber,
      ),


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Academic Information",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 25),


            TextField(

              controller: academicYearController,

              decoration: const InputDecoration(
                labelText: "Academic Year (Example: 2026/2027)",
                border: OutlineInputBorder(),
              ),

            ),


            const SizedBox(height: 15),


            ListTile(

              title: Text(
                startDate == null
                    ? "Select Opening Date"
                    : "Opening Date: ${startDate!.day}/${startDate!.month}/${startDate!.year}",
              ),

              trailing: const Icon(Icons.calendar_month),

              onTap: pickStartDate,

            ),


            const SizedBox(height: 10),


            ListTile(

              title: Text(
                endDate == null
                    ? "Select Closing Date"
                    : "Closing Date: ${endDate!.day}/${endDate!.month}/${endDate!.year}",
              ),

              trailing: const Icon(Icons.calendar_month),

              onTap: pickEndDate,

            ),


            const SizedBox(height: 15),


            DropdownButtonFormField<String>(

              initialValue: terms,

              decoration: const InputDecoration(
                labelText: "Number of Terms",
                border: OutlineInputBorder(),
              ),


              items: const [

                DropdownMenuItem(
                  value: "Select Number of Terms",
                  child: Text("Select Number of Terms"),
                ),

                DropdownMenuItem(
                  value: "1 Term",
                  child: Text("1 Term"),
                ),

                DropdownMenuItem(
                  value: "2 Terms",
                  child: Text("2 Terms"),
                ),

                DropdownMenuItem(
                  value: "3 Terms",
                  child: Text("3 Terms"),
                ),

              ],


              onChanged: (value){

                setState(() {

                  terms = value!;

                });

              },

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

                  ScaffoldMessenger.of(context).showSnackBar(

                    const SnackBar(
                      content: Text(
                        "Academic information saved",
                      ),
                    ),

                  );

                },


                child: const Text(
                  "CONTINUE",
                  style: TextStyle(
                    fontSize: 18,
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