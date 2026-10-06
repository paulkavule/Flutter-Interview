import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'registration/registration_api.dart';
import 'registration/registration_screen.dart';

void main() => runApp(RegistrationApp());

class RegistrationApp extends StatelessWidget {
  /// [api] is injectable so tests can substitute a fake HTTP client.
  RegistrationApp({super.key, RegistrationApi? api})
    : api = api ?? RegistrationApi();

  final RegistrationApi api;

  static final _theme = buildAppTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create account',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      home: RegistrationScreen(api: api),
    );
  }
}
