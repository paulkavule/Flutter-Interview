import '../data/models/registration_payload.dart';

abstract class RegistrationEvent {
  const RegistrationEvent();
}

class RegistrationAccountTypeChanged extends RegistrationEvent {
  final AccountType accountType;
  const RegistrationAccountTypeChanged(this.accountType);
}

class RegistrationSubmitted extends RegistrationEvent {
  final RegistrationPayload payload;
  const RegistrationSubmitted(this.payload);
}
