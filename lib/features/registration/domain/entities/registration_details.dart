import 'package:equatable/equatable.dart';

import 'account_type.dart';

class RegistrationDetails extends Equatable {
  const RegistrationDetails({
    required this.accountType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.companyName,
  });

  final AccountType accountType;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  final String? companyName;

  @override
  List<Object?> get props => [
    accountType,
    firstName,
    lastName,
    email,
    password,
    companyName,
  ];
}
