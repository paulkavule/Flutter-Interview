import '../../domain/entities/registered_user.dart';

class RegisteredUserModel extends RegisteredUser {
  const RegisteredUserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.companyName,
  });

  factory RegisteredUserModel.fromJson(Map<String, dynamic> json) {
    return RegisteredUserModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      companyName: json['company']?['name'] as String?,
    );
  }
}
