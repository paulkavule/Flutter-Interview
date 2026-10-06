import '../data/models/registration_payload.dart';

enum RegistrationStatus { initial, loading, success, failure }

class RegistrationState {
  final RegistrationStatus status;
  final AccountType accountType;
  final dynamic createdUserId;
  final String? errorMessage;

  const RegistrationState({
    this.status = RegistrationStatus.initial,
    this.accountType = AccountType.individual,
    this.createdUserId,
    this.errorMessage,
  });

  RegistrationState copyWith({
    RegistrationStatus? status,
    AccountType? accountType,
    dynamic createdUserId,
    String? errorMessage,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      accountType: accountType ?? this.accountType,
      createdUserId: createdUserId ?? this.createdUserId,
      errorMessage: errorMessage,
    );
  }
}
