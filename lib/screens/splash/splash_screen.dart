import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import '../login/login_screen.dart';
import '../welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _startApplication();
  }

  Future<void> _startApplication() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    if (!mounted) {
      return;
    }

    bool setupComplete = false;

    try {
      setupComplete =
          await DatabaseHelper.instance
              .isInitialSetupComplete();
    } catch (_) {
      setupComplete = false;
    }

    if (!mounted) {
      return;
    }

    if (!setupComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const WelcomeScreen(),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 90,
              color: Colors.amber,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'ChampionOne',
              style: TextStyle(
                fontSize: 34,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'School Management System',
            ),
          ],
        ),
      ),
    );
  }
}