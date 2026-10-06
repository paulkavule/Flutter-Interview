import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'features/registration/presentation/bloc/registration_bloc.dart';
import 'features/registration/presentation/pages/registration_page.dart';

void main() {
  initDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegistrationBloc>(),
      child: MaterialApp(
        title: 'Registration',
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        home: const RegistrationPage(),
      ),
    );
  }
}
