import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import '../../models/user_account_model.dart';
import '../../services/auth_service.dart';
import 'account_debug_screen.dart';
import '../../services/auth_session.dart';
import '../../services/role_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final school =
          await DatabaseHelper.instance
              .getCurrentSchool();

      if (!mounted) {
        return;
      }

      if (school == null) {
        throw Exception(
          'No school is configured on this device.',
        );
      }

      final schoolId = int.tryParse(
        '${school['id']}',
      );

      if (schoolId == null) {
        throw Exception(
          'The configured school has an invalid ID.',
        );
      }

      final UserAccount account =
          await AuthService.instance.login(
        schoolId: schoolId,
        username:
            _usernameController.text.trim(),
        password:
            _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      await _handleLoginSuccess(account);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error
            .toString()
            .replaceFirst(
              'Exception: ',
              '',
            );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ChampionOne Login',
        ),
        backgroundColor:
            Colors.amber,
        foregroundColor:
            Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 450,
            ),
            child: Card(
              elevation: 4,
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.school,
                        size: 70,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Welcome Back',
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Sign in to ChampionOne',
                        textAlign:
                            TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller:
                            _usernameController,
                        enabled: !_isLoading,
                        textInputAction:
                            TextInputAction.next,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Username',
                          hintText:
                              'Enter your username',
                          prefixIcon:
                              Icon(
                            Icons.person,
                          ),
                          border:
                              OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final username =
                              value?.trim() ??
                                  '';

                          if (username.isEmpty) {
                            return 'Username is required.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller:
                            _passwordController,
                        enabled: !_isLoading,
                        obscureText:
                            _obscurePassword,
                        textInputAction:
                            TextInputAction.done,
                        onFieldSubmitted:
                            (_) => _login(),
                        decoration:
                            InputDecoration(
                          labelText:
                              'Password',
                          hintText:
                              'Enter your password',
                          prefixIcon:
                              const Icon(
                            Icons.lock,
                          ),
                          suffixIcon:
                              IconButton(
                            tooltip:
                                _obscurePassword
                                    ? 'Show password'
                                    : 'Hide password',
                            onPressed:
                                _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          _obscurePassword =
                                              !_obscurePassword;
                                        });
                                      },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          border:
                              const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Password is required.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (_errorMessage !=
                          null) ...[
                        Container(
                          padding:
                              const EdgeInsets.all(
                            12,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                Colors.red.shade50,
                            borderRadius:
                                BorderRadius.circular(
                              8,
                            ),
                            border:
                                Border.all(
                              color:
                                  Colors.red.shade200,
                            ),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color:
                                  Colors.red.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                      SizedBox(
                        height: 52,
                        child:
                            ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                  ),
                                )
                              : const Text(
                                  'LOGIN',
                                  style:
                                      TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 12),

OutlinedButton.icon(
  onPressed: _isLoading
      ? null
      : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const AccountDebugScreen(),
            ),
          );
        },
  icon: const Icon(
    Icons.manage_accounts,
  ),
  label: const Text(
    'VIEW SAVED ACCOUNTS',
  ),
),

const SizedBox(
  height: 16,
),

const Text(
  'Your account must be active to sign in.',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 12,
  ),
),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Your account must be active to sign in.',
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    }

  Future<void> _handleLoginSuccess(
    UserAccount account,
  ) async {
    AuthSession.instance.signIn(account);

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RoleRouter.dashboardFor(
          account: account,
        ),
      ),
    );
  }
}