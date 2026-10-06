// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserResponseDto {

 int get id; String get firstName; String get email;
/// Create a copy of UserResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserResponseDtoCopyWith<UserResponseDto> get copyWith => _$UserResponseDtoCopyWithImpl<UserResponseDto>(this as UserResponseDto, _$identity);

  /// Serializes this UserResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserResponseDto&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,email);

@override
String toString() {
  return 'UserResponseDto(id: $id, firstName: $firstName, email: $email)';
}


}

/// @nodoc
abstract mixin class $UserResponseDtoCopyWith<$Res>  {
  factory $UserResponseDtoCopyWith(UserResponseDto value, $Res Function(UserResponseDto) _then) = _$UserResponseDtoCopyWithImpl;
@useResult
$Res call({
 int id, String firstName, String email
});




}
/// @nodoc
class _$UserResponseDtoCopyWithImpl<$Res>
    implements $UserResponseDtoCopyWith<$Res> {
  _$UserResponseDtoCopyWithImpl(this._self, this._then);

  final UserResponseDto _self;
  final $Res Function(UserResponseDto) _then;

/// Create a copy of UserResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? email = null,}) {
  return _then(UserResponseDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserResponseDto].
extension UserResponseDtoPatterns on UserResponseDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserResponseDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _UserResponseDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserResponseDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String firstName,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserResponseDto() when $default != null:
return $default(_that.id,_that.firstName,_that.email);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String firstName,  String email)  $default,) {final _that = this;
switch (_that) {
case _UserResponseDto():
return $default(_that.id,_that.firstName,_that.email);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String firstName,  String email)?  $default,) {final _that = this;
switch (_that) {
case _UserResponseDto() when $default != null:
return $default(_that.id,_that.firstName,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserResponseDto implements UserResponseDto {
  const _UserResponseDto({required this.id, required this.firstName, required this.email});
  factory _UserResponseDto.fromJson(Map<String, dynamic> json) => _$UserResponseDtoFromJson(json);

@override final  int id;
@override final  String firstName;
@override final  String email;

/// Create a copy of UserResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserResponseDtoCopyWith<_UserResponseDto> get copyWith => __$UserResponseDtoCopyWithImpl<_UserResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserResponseDto&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,email);

@override
String toString() {
  return 'UserResponseDto(id: $id, firstName: $firstName, email: $email)';
}


}

/// @nodoc
abstract mixin class _$UserResponseDtoCopyWith<$Res> implements $UserResponseDtoCopyWith<$Res> {
  factory _$UserResponseDtoCopyWith(_UserResponseDto value, $Res Function(_UserResponseDto) _then) = __$UserResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String firstName, String email
});




}
/// @nodoc
class __$UserResponseDtoCopyWithImpl<$Res>
    implements _$UserResponseDtoCopyWith<$Res> {
  __$UserResponseDtoCopyWithImpl(this._self, this._then);

  final _UserResponseDto _self;
  final $Res Function(_UserResponseDto) _then;

/// Create a copy of UserResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? email = null,}) {
  return _then(_UserResponseDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
