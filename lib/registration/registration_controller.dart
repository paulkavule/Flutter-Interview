import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../data/account_type.dart';
import '../data/company.dart';
import '../data/registration_exception.dart';
import '../data/registration_request.dart';
import '../data/user_repository.dart';
import 'registration_state.dart';

class RegistrationController extends GetxController {
  RegistrationController({required this.repository});

  final UserRepository repository;

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final companyController = TextEditingController();

  final accountType = AccountType.individual.obs;
  final state = Rx<RegistrationState>(const RegistrationIdle());

  bool get isBusiness => accountType.value == AccountType.business;
  bool get isLoading => state.value is RegistrationSubmitting;

  Future<void> submit() async {
    if (isLoading) return;
    if (!formKey.currentState!.validate()) return;

    final request = RegistrationRequest(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      company: isBusiness ? Company(name: companyController.text.trim()) : null,
    );

    state.value = const RegistrationSubmitting();
    try {
      final user = await repository.register(request);
      state.value = RegistrationSuccess(user);
    } on RegistrationException catch (e) {
      state.value = RegistrationFailure(e.message);
    }
  }

  void reset() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    companyController.clear();
    accountType.value = AccountType.individual;
    state.value = const RegistrationIdle();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    companyController.dispose();
    super.onClose();
  }
}
