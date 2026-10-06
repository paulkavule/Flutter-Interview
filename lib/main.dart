import 'package:flutter/material.dart';

import 'screens/registration_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5EFF)),
      ),
      home: RegistrationScreen(api: ApiService()),
    );
  }
}
