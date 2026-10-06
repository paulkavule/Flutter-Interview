import 'package:flutter/material.dart';
import '../../data/models/registration_payload.dart';

class AccountTypeSelector extends StatelessWidget {
  final AccountType selectedType;
  final ValueChanged<AccountType>? onTypeChanged;
  final bool enabled;

  const AccountTypeSelector({
    super.key,
    required this.selectedType,
    this.onTypeChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        ChoiceChip(
          label: const Text('Individual'),
          avatar: const Icon(Icons.person, size: 18),
          selected: selectedType == AccountType.individual,
          onSelected: enabled
              ? (selected) {
                  if (selected) {
                    onTypeChanged?.call(AccountType.individual);
                  }
                }
              : null,
        ),
        ChoiceChip(
          label: const Text('Business'),
          avatar: const Icon(Icons.business, size: 18),
          selected: selectedType == AccountType.business,
          onSelected: enabled
              ? (selected) {
                  if (selected) {
                    onTypeChanged?.call(AccountType.business);
                  }
                }
              : null,
        ),
      ],
    );
  }
}
