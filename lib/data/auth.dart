import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_search/config/api.config.dart';
import 'package:product_search/data/endpoints.dart';
import 'package:product_search/models/user.dart';

class AuthRepository {
  AuthRepository({http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;

  Future<User> register(User user) async {
    final response = await _client
        .post(
          ApiEndpoints.register,
          headers: {
            'Accept': ApiConfig.contentType,
            'Content-Type': ApiConfig.contentType,
          },
          body: jsonEncode(user.toJson()),
        )
        .timeout(ApiConfig.requestTimeout);

    final result = jsonDecode(response.body);
   
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RegistrationException(
        result['message']?.toString() ??
            'Something went wrong!.',
      );
    }

    return User.fromJson(result);
  }

  void dispose() {
    if (_ownsClient) _client.close();
  }
}

class RegistrationException implements Exception {
  const RegistrationException(this.message);

  final String message;

  @override
  String toString() => message;
}
