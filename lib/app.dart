import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';

class ChampionOneApp extends StatelessWidget {
  const ChampionOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "ChampionOne",

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
        ),
        useMaterial3: true,
      ),

      home: SplashScreen(),
    );
  }
}