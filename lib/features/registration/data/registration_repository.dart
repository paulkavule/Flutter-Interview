import 'package:dio/dio.dart';
import '../domain/repositories/i_registration_repository.dart';
import 'models/registration_payload.dart';

class RegistrationRepository implements IRegistrationRepository {
  final Dio _dio;

  RegistrationRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://dummyjson.com',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {'Content-Type': 'application/json'},
              ),
            );

  @override
  Future<Map<String, dynamic>> registerUser(RegistrationPayload payload) async {
    try {
      final response = await _dio.post(
        '/users/add',
        data: payload.toJson(),
      );

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'message': 'Registration completed'};
    } on DioException catch (e) {
      final serverMessage = e.response?.data is Map
          ? (e.response?.data as Map)['message']?.toString()
          : null;
      throw Exception(serverMessage ?? e.message ?? 'Registration failed. Please try again.');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
