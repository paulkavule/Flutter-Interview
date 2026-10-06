import 'package:flutter/material.dart';

import 'registration/registration_screen.dart';

void main() {
  runApp(const RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});
  static const _title = 'Registration Form';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const RegistrationScreen(),
    );
  }
}

