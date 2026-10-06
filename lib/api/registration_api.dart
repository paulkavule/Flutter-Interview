import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

enum AccountType { individual, business }

class RegistrationRequest {
  const RegistrationRequest({
    required this.accountType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.companyName,
  });

  final AccountType accountType;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? companyName;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        if (accountType == AccountType.business)
          'company': {'name': companyName},
      };
}

class RegistrationException implements Exception {
  const RegistrationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RegistrationApi {
  RegistrationApi({http.Client? client}) : _client = client ?? http.Client();

  static final _endpoint = Uri.parse('https://dummyjson.com/users/add');

  final http.Client _client;

  /// Returns the ID assigned to the newly created user.
  Future<int> register(RegistrationRequest request) async {
    final http.Response response;
    try {
      response = await _client
          .post(
            _endpoint,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const RegistrationException('The request timed out. Try again.');
    } on http.ClientException {
      throw const RegistrationException(
        'Could not reach the server. Check your connection.',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RegistrationException(
        'Registration failed (HTTP ${response.statusCode}).',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['id'] as int;
  }

  void dispose() => _client.close();
}
