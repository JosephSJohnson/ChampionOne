import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
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
              'System Settings',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage ChampionOne school system settings.',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 30),

            _settingsCard(
              icon: Icons.school,
              title: 'School Information',
              subtitle:
                  'View and manage school information.',
              onTap: () {},
            ),

            _settingsCard(
              icon: Icons.calendar_month,
              title: 'Academic Year Settings',
              subtitle:
                  'Manage academic year configuration.',
              onTap: () {},
            ),

            _settingsCard(
              icon: Icons.security,
              title: 'Security',
              subtitle:
                  'Manage security and account settings.',
              onTap: () {},
            ),

            _settingsCard(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle:
                  'Manage system notifications.',
              onTap: () {},
            ),

            _settingsCard(
              icon: Icons.backup,
              title: 'Backup and Recovery',
              subtitle:
                  'Manage database backup and recovery.',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 4,
          ),
          child: Text(subtitle),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}