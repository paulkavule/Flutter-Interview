import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company extends Equatable {
  const Company({required this.name});

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  final String name;

  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  @override
  List<Object?> get props => [name];
}
