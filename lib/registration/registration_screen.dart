import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/registration_form.dart';
import '../widgets/success_view.dart';
import 'registration_controller.dart';
import 'registration_state.dart';

class RegistrationScreen extends GetView<RegistrationController> {
  const RegistrationScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: Obx(() {
        final state = controller.state.value;
        if (state is RegistrationSuccess) {
          return SuccessView(user: state.user, onDone: controller.reset);
        }
        return const RegistrationForm();
      }),
    );
  }
}
