import 'package:flutter/material.dart';

import 'api/registration_api.dart';
import 'screens/registration_screen.dart';

void main() {
  runApp(MainApp(api: RegistrationApi()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.api});

  final RegistrationApi api;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: RegistrationScreen(api: api),
    );
  }
}
