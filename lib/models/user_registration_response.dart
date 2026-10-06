
class UserRegistrationResponse {
  const UserRegistrationResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.companyName,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? companyName;

  bool get isBusiness => companyName != null && companyName!.isNotEmpty;

  factory UserRegistrationResponse.fromJson(Map<String, dynamic> json) {
    final company = json['company'];
    return UserRegistrationResponse(
      id: (json['id'] as num).toInt(),
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      companyName: company is Map ? company['name'] as String? : null,
    );
  }
}
