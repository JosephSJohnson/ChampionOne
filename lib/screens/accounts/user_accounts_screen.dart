import 'package:flutter/material.dart';

import '../../database/database_helper.dart';

class UserAccountsScreen extends StatefulWidget {
  const UserAccountsScreen({
    super.key,
  });

  @override
  State<UserAccountsScreen> createState() =>
      _UserAccountsScreenState();
}

class _UserAccountsScreenState
    extends State<UserAccountsScreen> {
  bool isLoading = true;

  List<Map<String, dynamic>> accounts = [];

  @override
  void initState() {
    super.initState();

    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      final school =
          await DatabaseHelper.instance
              .getCurrentSchool();

      if (school == null) {
        throw Exception(
          'No current school was found.',
        );
      }

      final schoolId =
          int.tryParse('${school['id']}');

      if (schoolId == null) {
        throw Exception(
          'The current school has an invalid ID.',
        );
      }

      final result =
          await DatabaseHelper.instance
              .getUserAccounts(schoolId);

      if (!mounted) {
        return;
      }

      setState(() {
        accounts = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Failed to load user accounts: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Accounts',
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : accounts.isEmpty
              ? const Center(
                  child: Text(
                    'No user accounts found.',
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: accounts.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    final account =
                        accounts[index];

                    return Card(
                      margin:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.person,
                          ),
                        ),
                        title: Text(
                          '${account['displayName'] ?? ''}',
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding:
                              const EdgeInsets
                                  .only(
                            top: 6,
                          ),
                          child: Text(
                            'Username: '
                            '${account['username'] ?? ''}\n'
                            'Title: '
                            '${account['displayTitle'] ?? ''}\n'
                            'Role: '
                            '${account['systemRole'] ?? ''}\n'
                            'Status: '
                            '${account['accountStatus'] ?? ''}',
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}