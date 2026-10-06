import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'company.dart';

part 'registration_request.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RegistrationRequest extends Equatable {
  const RegistrationRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.company,
  });

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestFromJson(json);

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final Company? company;

  Map<String, dynamic> toJson() => _$RegistrationRequestToJson(this);

  @override
  List<Object?> get props => [firstName, lastName, email, password, company];
}
