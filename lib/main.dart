import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/registration/bloc/registration_bloc.dart';
import 'features/registration/data/registration_repository.dart';
import 'features/registration/domain/repositories/i_registration_repository.dart';
import 'features/registration/domain/usecases/register_user.dart';
import 'features/registration/presentation/registration_page.dart';

void main() {
  final IRegistrationRepository registrationRepository = RegistrationRepository();
  final registerUser = RegisterUser(registrationRepository);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IRegistrationRepository>.value(
          value: registrationRepository,
        ),
        RepositoryProvider<RegisterUser>.value(
          value: registerUser,
        ),
      ],
      child: BlocProvider(
        create: (context) => RegistrationBloc(
          registerUser: context.read<RegisterUser>(),
        ),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RegistrationPage(),
    );
  }
}
