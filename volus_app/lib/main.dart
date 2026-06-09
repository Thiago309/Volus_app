import 'package:flutter/material.dart';
import 'package:volus_app/core/theme/teto_colors.dart';
import 'package:volus_app/features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voluts TETO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: TetoColors.primaryBlue,
          primary: TetoColors.primaryBlue,
          secondary: TetoColors.primaryGreen,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(),
    );
  }
}
