import 'company.dart';

class User {
  const User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int?,
    firstName: json['firstName'] as String? ?? '',
    lastName: json['lastName'] as String? ?? '',
    email: json['email'] as String? ?? '',
    password: json['password'] as String? ?? '',
    company: json['company'] == null
        ? null
        : Company.fromJson(json['company'] as Map<String, dynamic>),
  );

  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final Company? company;

  bool get isBusiness => company != null;

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password,
    if (company != null) 'company': company!.toJson(),
  };
}
