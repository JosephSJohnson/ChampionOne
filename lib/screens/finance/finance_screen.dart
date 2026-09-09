import 'package:flutter/material.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finance',
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Finance Management',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Manage school fees, payments, balances, '
              'financial records, and reports.',
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
                _financeCard(
                  icon: Icons.receipt_long,
                  title: 'Fee Structure',
                  onTap: () {},
                ),

                _financeCard(
                  icon: Icons.payments,
                  title: 'Record Payment',
                  onTap: () {},
                ),

                _financeCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Student Balances',
                  onTap: () {},
                ),

                _financeCard(
                  icon: Icons.history,
                  title: 'Payment History',
                  onTap: () {},
                ),

                _financeCard(
                  icon: Icons.bar_chart,
                  title: 'Financial Reports',
                  onTap: () {},
                ),

                _financeCard(
                  icon: Icons.settings,
                  title: 'Finance Settings',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _financeCard({
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