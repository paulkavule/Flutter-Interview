import 'package:flutter/material.dart';

import 'register/register_screen.dart';
import 'register/registration_service.dart';

void main() {
  runApp(MyApp(service: RegistrationService()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.service});

  final RegistrationService service;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration',
      home: RegisterScreen(service: service),
    );
  }
}
