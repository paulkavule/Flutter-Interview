import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'company.dart';

part 'registered_user.g.dart';

@JsonSerializable(createToJson: false)
class RegisteredUser extends Equatable {
  const RegisteredUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.company,
  });

  factory RegisteredUser.fromJson(Map<String, dynamic> json) =>
      _$RegisteredUserFromJson(json);

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final Company? company;

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, email, company];
}
