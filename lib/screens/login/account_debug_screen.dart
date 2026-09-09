import 'package:flutter/material.dart';

import '../../database/database_helper.dart';

class AccountDebugScreen extends StatefulWidget {
  const AccountDebugScreen({super.key});

  @override
  State<AccountDebugScreen> createState() =>
      _AccountDebugScreenState();
}

class _AccountDebugScreenState
    extends State<AccountDebugScreen> {
  List<Map<String, dynamic>> accounts = [];
  String? errorMessage;
  bool isLoading = true;

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
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Diagnostic',
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : errorMessage != null
                ? Center(
                    child: Text(
                      errorMessage!,
                    ),
                  )
                : accounts.isEmpty
                    ? const Center(
                        child: Text(
                          'No user accounts found.',
                        ),
                      )
                    : ListView.builder(
                        itemCount: accounts.length,
                        itemBuilder:
                            (context, index) {
                          final account =
                              accounts[index];

                          return Card(
                            margin:
                                const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(
                                16,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    'Account #${account['id']}',
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Username: ${account['username']}',
                                  ),
                                  Text(
                                    'Name: ${account['displayName']}',
                                  ),
                                  Text(
                                    'Title: ${account['displayTitle']}',
                                  ),
                                  Text(
                                    'System Role: ${account['systemRole']}',
                                  ),
                                  Text(
                                    'Status: ${account['accountStatus']}',
                                  ),
                                  Text(
                                    'School ID: ${account['schoolId']}',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}