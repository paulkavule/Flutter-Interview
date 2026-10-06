// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserResponseDto _$UserResponseDtoFromJson(Map<String, dynamic> json) =>
    _UserResponseDto(
      id: (json['id'] as num).toInt(),
      firstName: json['firstName'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserResponseDtoToJson(_UserResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'email': instance.email,
    };
