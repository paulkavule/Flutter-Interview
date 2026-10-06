import 'package:dio/dio.dart';

import 'registered_user.dart';
import 'registration_request.dart';

class UserApi {
  UserApi(this._dio);

  final Dio _dio;

  Future<RegisteredUser> addUser(RegistrationRequest request) async {
    final response = await _dio.post('/users/add', data: request.toJson());
    return RegisteredUser.fromJson(response.data);
  }
}
