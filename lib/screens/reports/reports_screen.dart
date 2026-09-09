import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports',
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
            const Text(
              'Reports Management',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Generate and review school management '
              'reports.',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 30),
            GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.15,
              children: [
                _reportCard(
                  icon: Icons.people,
                  title: 'Staff Reports',
                  onTap: () {},
                ),
                _reportCard(
                  icon: Icons.school,
                  title: 'Student Reports',
                  onTap: () {},
                ),
                _reportCard(
                  icon: Icons.menu_book,
                  title: 'Academic Reports',
                  onTap: () {},
                ),
                _reportCard(
                  icon: Icons.attach_money,
                  title: 'Financial Reports',
                  onTap: () {},
                ),
                _reportCard(
                  icon: Icons.fact_check,
                  title: 'Attendance Reports',
                  onTap: () {},
                ),
                _reportCard(
                  icon: Icons.assessment,
                  title: 'General Reports',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 42,
              ),
              const SizedBox(height: 14),
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