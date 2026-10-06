import 'package:dio/dio.dart';

class ApiService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com/',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ),
  );

  Future<Map<String, dynamic>> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
    Map<String, dynamic> company,
  ) async {
    try {
      final response = await _dio.post(
        '/users/add',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'company': company,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to register user');
      }
    } on DioException catch (e) {
      rethrow;
    }
  }
}
