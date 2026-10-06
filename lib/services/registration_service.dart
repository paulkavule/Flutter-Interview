import 'package:dio/dio.dart';
import 'package:product_search/models/user_registration_request.dart';
import 'package:product_search/models/user_registration_response.dart';

class RegistrationException implements Exception {
  const RegistrationException(this.message);
  final String message;

  @override
  String toString() => message;
}

class RegistrationService {
  RegistrationService({Dio? dio})
      : _dio = dio ??
      Dio(
        BaseOptions(
          baseUrl: 'https://dummyjson.com',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          contentType: Headers.jsonContentType, // application/json
          responseType: ResponseType.json,
        ),
      );

  final Dio _dio;


  Future<UserRegistrationResponse> register(UserRegistrationRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/users/add',
        data: request.toJson(),
      );

      final data = response.data;
      if (data == null || data['id'] == null) {
        throw const RegistrationException('Unexpected response from server.');
      }
      return UserRegistrationResponse.fromJson(data);
    } on DioException catch (e) {
      throw RegistrationException(_messageFor(e));
    }
  }

  String _messageFor(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The request timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Check your network and retry.';
      case DioExceptionType.badResponse:
        final body = e.response?.data;
        if (body is Map && body['message'] is String) {
          return body['message'] as String;
        }
        return 'Server error (${e.response?.statusCode}). Please try again.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
