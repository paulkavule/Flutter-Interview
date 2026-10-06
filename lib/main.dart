import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'data/user_api.dart';
import 'data/user_repository.dart';
import 'registration/registration_binding.dart';
import 'registration/registration_screen.dart';

void main() {
  runApp(const RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Registration',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      initialBinding: BindingsBuilder(() {
        final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
        dio.interceptors.add(
          PrettyDioLogger(
            requestBody: true,
            requestHeader: true,
            enabled: kDebugMode,
          ),
        );
        Get.put<UserRepository>(UserRepositoryImpl(UserApi(dio)));
      }),
      initialRoute: RegistrationScreen.routeName,
      getPages: [
        GetPage(
          name: RegistrationScreen.routeName,
          page: () => const RegistrationScreen(),
          binding: RegistrationBinding(),
        ),
      ],
    );
  }
}
