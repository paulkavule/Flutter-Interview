part of 'registration_bloc.dart';

sealed class RegistrationEvent extends Equatable {
  const RegistrationEvent();
  @override
  List<Object?> get props => [];
}

final class AccountTypeChanged extends RegistrationEvent {
  const AccountTypeChanged(this.accountType);
  final AccountType accountType;

  @override
  List<Object> get props => [accountType];
}

final class RegistrationSubmitted extends RegistrationEvent {
  const RegistrationSubmitted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.companyName,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? companyName;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    companyName,
  ];
}
