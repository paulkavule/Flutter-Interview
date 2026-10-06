class UserRegistrationRequest {
  const UserRegistrationRequest({
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

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password,
    if (companyName != null) 'company': {'name': companyName},
  };
}