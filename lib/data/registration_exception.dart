import 'package:equatable/equatable.dart';

class RegistrationException extends Equatable implements Exception {
  const RegistrationException(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
