import 'package:flutter/material.dart';
import 'package:product_search/data/auth.dart';
import 'package:product_search/screens/registration.dart';

class Home extends StatelessWidget {
  const Home({super.key, this.authRepository});

  final AuthRepository? authRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create account',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: RegistrationScreen(authRepository: authRepository),
    );
  }
}
