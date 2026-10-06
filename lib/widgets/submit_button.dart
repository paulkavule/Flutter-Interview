import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../registration/registration_controller.dart';

class SubmitButton extends GetView<RegistrationController> {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 48,
        child: FilledButton(
          onPressed: controller.isLoading ? null : controller.submit,
          child: controller.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Register'),
        ),
      ),
    );
  }
}
