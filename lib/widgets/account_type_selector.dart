import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/account_type.dart';
import '../registration/registration_controller.dart';

class AccountTypeSelector extends GetView<RegistrationController> {
  const AccountTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SegmentedButton<AccountType>(
        segments: const [
          ButtonSegment(
            value: AccountType.individual,
            label: Text('Individual'),
          ),
          ButtonSegment(value: AccountType.business, label: Text('Business')),
        ],
        selected: {controller.accountType.value},
        onSelectionChanged: (value) =>
            controller.accountType.value = value.first,
      ),
    );
  }
}
