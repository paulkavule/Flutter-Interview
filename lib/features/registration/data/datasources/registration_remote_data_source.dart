import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';
import '../models/registered_user_model.dart';
import '../models/registration_request_model.dart';

abstract interface class RegistrationRemoteDataSource {
  Future<RegisteredUserModel> register(RegistrationRequestModel request);
}

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  const RegistrationRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<RegisteredUserModel> register(RegistrationRequestModel request) async {
    try {
      final response = await _dio.post('/users/add', data: request.toJson());
      return RegisteredUserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
