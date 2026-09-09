import 'package:flutter/material.dart';

import '../../models/user_account_model.dart';
import '../Setup/academic_setup_screen.dart';
import '../Setup/school_setup_screen.dart';
import '../accounts/user_accounts_screen.dart';
import '../finance/finance_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';
import '../support/support_screen.dart';
import '../staff/staff_management_screen.dart';
import '../student/student_management_screen.dart';

class AdministratorDashboardScreen extends StatelessWidget {
  final UserAccount account;

  const AdministratorDashboardScreen({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Administrator Dashboard',
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
              'Welcome, ${account.displayName}',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              account.displayTitle,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Role: ${account.systemRole}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.15,
              children: [
                _dashboardCard(
  context: context,
  icon: Icons.school,
  title: 'School Management',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SchoolSetupScreen(),
      ),
    );
  },
),
                _dashboardCard(
                  context: context,
                  icon: Icons.people,
                  title: 'Staff Management',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StaffManagementScreen(),
                      ),
                    );
                  },
                ),
                _dashboardCard(
                  context: context,
                  icon: Icons.person,
                  title: 'Student Management',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const StudentManagementScreen(),
                      ),
                    );
                  },
                ),
                _dashboardCard(
  context: context,
  icon: Icons.menu_book,
  title: 'Academic Setup',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AcademicSetupScreen(),
      ),
    );
  },
),
                _dashboardCard(
  context: context,
  icon: Icons.attach_money,
  title: 'Finance',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FinanceScreen(),
      ),
    );
  },
),
                _dashboardCard(
  context: context,
  icon: Icons.bar_chart,
  title: 'Reports',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ReportsScreen(),
      ),
    );
  },
),
                _dashboardCard(
  context: context,
  icon: Icons.manage_accounts,
  title: 'User Accounts',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UserAccountsScreen(),
      ),
    );
  },
),
                                _dashboardCard(
                  context: context,
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SettingsScreen(),
                      ),
                    );
                  },
                ),

                _dashboardCard(
                  context: context,
                  icon: Icons.support_agent,
                  title: 'Support Center',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SupportScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard({
    required BuildContext context,
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
            mainAxisAlignment: MainAxisAlignment.center,
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