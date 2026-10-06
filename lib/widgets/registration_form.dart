import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../registration/registration_controller.dart';
import '../registration/registration_state.dart';
import '../registration/registration_validators.dart';
import 'account_type_selector.dart';
import 'submit_button.dart';

class RegistrationForm extends GetView<RegistrationController> {
  const RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AccountTypeSelector(),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.firstNameController,
                    decoration: const InputDecoration(labelText: 'First name'),
                    validator: (value) =>
                        RegistrationValidators.required(value, 'First name'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: controller.lastNameController,
                    decoration: const InputDecoration(labelText: 'Last name'),
                    validator: (value) =>
                        RegistrationValidators.required(value, 'Last name'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: RegistrationValidators.email,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: RegistrationValidators.password,
            ),
            Obx(() {
              if (!controller.isBusiness) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  controller: controller.companyController,
                  decoration: const InputDecoration(labelText: 'Company name'),
                  validator: (value) =>
                      RegistrationValidators.required(value, 'Company name'),
                ),
              );
            }),
            const SizedBox(height: 24),
            Obx(() {
              final state = controller.state.value;
              if (state is! RegistrationFailure) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  state.message,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
            }),
            const SubmitButton(),
          ],
        ),
      ),
    );
  }
}
