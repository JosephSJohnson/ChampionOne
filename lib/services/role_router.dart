import 'package:flutter/material.dart';

import '../models/user_account_model.dart';
import '../screens/admin/administrator_dashboard_screen.dart';
import '../screens/dashboard/proprietor_dashboard_screen.dart';

class RoleRouter {
  RoleRouter._();

  static Widget dashboardFor({
    required UserAccount account,
  }) {
    switch (account.systemRole.trim().toUpperCase()) {
      case 'ADMINISTRATOR':
        return AdministratorDashboardScreen(
          account: account,
        );

      case 'PROPRIETOR':
        return ProprietorDashboardScreen(
          proprietorName: account.displayName,
        );

      default:
        return Scaffold(
          appBar: AppBar(
            title: const Text('ChampionOne'),
          ),
          body: Center(
            child: Text(
              'No dashboard is configured for role '
              '"${account.systemRole}".',
              textAlign: TextAlign.center,
            ),
          ),
        );
    }
  }
}