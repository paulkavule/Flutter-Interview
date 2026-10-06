enum AccountType {
  individual('Individual'),
  business('Business');

  const AccountType(this.label);
  final String label;
}

class RegistrationRequest {
  const RegistrationRequest({
    required this.accountType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.companyName,
  }) : assert(
         accountType != AccountType.business || companyName != null,
         'Business accounts require a company name',
       );

  final AccountType accountType;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? companyName;

  Map<String, Object> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password,
    if (accountType == AccountType.business) 'company': {'name': companyName!},
  };
}

/// The subset of the API's response the UI needs to confirm creation.
class RegisteredUser {
  const RegisteredUser({
    required this.id,
    required this.firstName,
    required this.email,
    this.companyName,
  });

  /// DummyJSON echoes an empty `company` object for every user, so a blank
  /// name is normalised to `null` (an individual account).
  factory RegisteredUser.fromJson(Map<String, dynamic> json) {
    final company = (json['company'] as Map<String, dynamic>?)?['name'];
    return RegisteredUser(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      email: json['email'] as String,
      companyName: company is String && company.isNotEmpty ? company : null,
    );
  }

  final int id;
  final String firstName;
  final String email;
  final String? companyName;
}
