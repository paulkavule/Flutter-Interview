import '../../domain/entities/account_type.dart';
import '../../domain/entities/registration_details.dart';

class RegistrationRequestModel {
  const RegistrationRequestModel(this.details);

  final RegistrationDetails details;

  Map<String, dynamic> toJson() => {
    'firstName': details.firstName,
    'lastName': details.lastName,
    'email': details.email,
    'password': details.password,
    if (details.accountType == AccountType.business)
      'company': {'name': details.companyName},
  };
}
