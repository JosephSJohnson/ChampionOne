import 'package:flutter/material.dart';
import 'ai_support_assistant_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support Center',
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
              'ChampionOne Support Center',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Get help, learn how to use ChampionOne, '
              'and report problems.',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 30),

            _supportCard(
              icon: Icons.menu_book,
              title: 'Help & User Guides',
              subtitle:
                  'Learn how to use ChampionOne modules '
                  'and features.',
              onTap: () {},
            ),

            _supportCard(
              icon: Icons.question_answer,
              title: 'Frequently Asked Questions',
              subtitle:
                  'Find answers to common ChampionOne questions.',
              onTap: () {},
            ),

            _supportCard(
              icon: Icons.support_agent,
              title: 'AI Support Assistant',
              subtitle:
                  'Get guided help and troubleshooting '
                  'from the ChampionOne AI assistant.',
             onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const AiSupportAssistantScreen(),
    ),
  );
},
            ),

            _supportCard(
              icon: Icons.report_problem,
              title: 'Report a Problem',
              subtitle:
                  'Tell us about an issue you are experiencing.',
              onTap: () {},
            ),

            _supportCard(
              icon: Icons.contact_support,
              title: 'Contact ChampionOne Support',
              subtitle:
                  'Get assistance from the ChampionOne support team.',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportCard({
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
        contentPadding:
            const EdgeInsets.symmetric(
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
          child: Text(
            subtitle,
          ),
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