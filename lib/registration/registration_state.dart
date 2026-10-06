import 'package:equatable/equatable.dart';

import '../data/registered_user.dart';

sealed class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationIdle extends RegistrationState {
  const RegistrationIdle();
}

class RegistrationSubmitting extends RegistrationState {
  const RegistrationSubmitting();
}

class RegistrationSuccess extends RegistrationState {
  const RegistrationSuccess(this.user);

  final RegisteredUser user;

  @override
  List<Object?> get props => [user];
}

class RegistrationFailure extends RegistrationState {
  const RegistrationFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
