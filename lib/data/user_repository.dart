import 'package:dio/dio.dart';

import 'registered_user.dart';
import 'registration_exception.dart';
import 'registration_request.dart';
import 'user_api.dart';

abstract class UserRepository {
  Future<RegisteredUser> register(RegistrationRequest request);
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._api);

  final UserApi _api;

  @override
  Future<RegisteredUser> register(RegistrationRequest request) async {
    try {
      return await _api.addUser(request);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        throw RegistrationException(data['message'].toString());
      }
      throw const RegistrationException(
        'Registration failed, please try again',
      );
    }
  }
}
