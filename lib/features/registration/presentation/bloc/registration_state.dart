import 'package:equatable/equatable.dart';

import '../../domain/entities/account_type.dart';
import '../../domain/entities/registered_user.dart';

sealed class RegistrationState extends Equatable {
  const RegistrationState(this.accountType);
  final AccountType accountType;

  @override
  List<Object?> get props => [accountType];
}

final class RegistrationInitial extends RegistrationState {
  const RegistrationInitial([super.accountType = AccountType.individual]);
}

final class RegistrationLoading extends RegistrationState {
  const RegistrationLoading(super.accountType);
}

final class RegistrationSuccess extends RegistrationState {
  const RegistrationSuccess(super.accountType, this.user);
  final RegisteredUser user;

  @override
  List<Object?> get props => [accountType, user];
}

final class RegistrationFailure extends RegistrationState {
  const RegistrationFailure(super.accountType, this.message);
  final String message;

  @override
  List<Object?> get props => [accountType, message];
}
