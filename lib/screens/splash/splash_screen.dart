import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
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

    bool setupCompleted = false;

    try {
      setupCompleted =
          await DatabaseHelper.instance
              .isSetupCompleted();
    } catch (_) {
      setupCompleted = false;
    }

    if (!mounted) {
      return;
    }

    // ----------------------------------------------------------
    // VERSION 10
    //
    // For now, an unconfigured system goes to Welcome.
    // The login screen will be connected in a later phase
    // when authentication is implemented.
    // ----------------------------------------------------------

    if (!setupCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const WelcomeScreen(),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // TEMPORARY FALLBACK
    //
    // Authentication is not implemented yet.
    // Once authentication is built, this branch will go to
    // the LoginScreen instead.
    // ----------------------------------------------------------

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const WelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

            const SizedBox(height: 20),

            const Text(
              "ChampionOne",
              style: TextStyle(
                fontSize: 34,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "School Management System",
            ),
          ],
        ),
      ),
    );
  }
}