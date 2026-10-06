enum AccountType { individual, business }

class RegistrationPayload {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final AccountType accountType;
  final String? companyName;

  const RegistrationPayload({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.accountType,
    this.companyName,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };

    if (accountType == AccountType.business &&
        companyName != null &&
        companyName!.trim().isNotEmpty) {
      data['company'] = {
        'name': companyName!.trim(),
      };
    }

    return data;
  }
}
