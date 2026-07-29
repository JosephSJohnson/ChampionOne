import 'package:flutter/material.dart';
import 'institution_head_setup_screen.dart';

class RoleSetupScreen extends StatefulWidget {
  const RoleSetupScreen({super.key});

  @override
  State<RoleSetupScreen> createState() => _RoleSetupScreenState();
}

class _RoleSetupScreenState extends State<RoleSetupScreen> {

  String headTitle = "Proprietor";
  String principalTitle = "Principal";
  String vicePrincipalTitle = "Vice Principal";
  String academicTitle = "VP Academic Affairs";
  String studentAffairsTitle = "VP Student Affairs";
  String financeTitle = "Finance Officer";
  String teacherTitle = "Teacher";

  final List<String> headTitles = [
  "Proprietor",
  "Proprietress",
  "Director",
  "Executive Director",
  "President",
  "CEO",
];

  final List<String> principalTitles = [
    "Principal",
    "Headmaster",
    "Headmistress",
    "Head Teacher",
  ];

  final List<String> vicePrincipalTitles = [
    "Vice Principal",
    "Assistant Principal",
    "Deputy Head Teacher",
  ];

  final List<String> academicTitles = [
    "VP Academic Affairs",
    "Dean of Academics",
    "Academic Director",
  ];

  final List<String> studentAffairsTitles = [
    "VP Student Affairs",
    "Dean of Students",
    "Student Affairs Director",
  ];

  final List<String> financeTitles = [
    "Finance Officer",
    "Bursar",
    "Accountant",
  ];

  final List<String> teacherTitles = [
    "Teacher",
    "Instructor",
    "Tutor",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leadership Titles"),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        "Customize your school leadership titles",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),

      const SizedBox(height: 25),

      _buildDropdown(
        title: "Head of Institution",
        value: headTitle,
        items: headTitles,
        onChanged: (value) {
          setState(() {
            headTitle = value!;
          });
        },
      ),

      _buildDropdown(
        title: "Principal",
        value: principalTitle,
        items: principalTitles,
        onChanged: (value) {
          setState(() {
            principalTitle = value!;
          });
        },
      ),

      _buildDropdown(
        title: "Vice Principal",
        value: vicePrincipalTitle,
        items: vicePrincipalTitles,
        onChanged: (value) {
          setState(() {
            vicePrincipalTitle = value!;
          });
        },
      ),

      _buildDropdown(
        title: "Academic Head",
        value: academicTitle,
        items: academicTitles,
        onChanged: (value) {
          setState(() {
            academicTitle = value!;
          });
        },
      ),

      _buildDropdown(
        title: "Student Affairs Head",
        value: studentAffairsTitle,
        items: studentAffairsTitles,
        onChanged: (value) {
          setState(() {
            studentAffairsTitle = value!;
          });
        },
      ),

      _buildDropdown(
        title: "Finance",
        value: financeTitle,
        items: financeTitles,
        onChanged: (value) {
          setState(() {
            financeTitle = value!;
          });
        },
      ),

      _buildDropdown(
        title: "Teacher",
        value: teacherTitle,
        items: teacherTitles,
        onChanged: (value) {
          setState(() {
            teacherTitle = value!;
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

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          InstitutionHeadSetupScreen(
            roleTitle: headTitle,
          ),
    ),
  );

},
          child: const Text(
            "SAVE & CONTINUE",
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


  Widget _buildDropdown({
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          initialValue: value,

          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),

          items: items.map((item) {

            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );

          }).toList(),

          onChanged: onChanged,
        ),

        const SizedBox(height: 20),

      ],
    );
  }
}