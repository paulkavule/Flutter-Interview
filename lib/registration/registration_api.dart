import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'registration_models.dart';

/// A failure the UI can show to the user verbatim.
class RegistrationException implements Exception {
  const RegistrationException(this.message);
  final String message;

  @override
  String toString() => 'RegistrationException: $message';
}

/// Client for DummyJSON's simulated user-creation endpoint.
///
/// Transport, timeout and server errors are all normalised into
/// [RegistrationException] so callers handle a single failure type.
/// The [http.Client] is injectable for testing.
class RegistrationApi {
  RegistrationApi({http.Client? client}) : _client = client ?? http.Client();

  static final _endpoint = Uri.https('dummyjson.com', '/users/add');
  static const _timeout = Duration(seconds: 15);

  final http.Client _client;

  Future<RegisteredUser> register(RegistrationRequest request) async {
    final http.Response response;
    try {
      response = await _client
          .post(
            _endpoint,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const RegistrationException(
        'The server took too long to respond. Please try again.',
      );
    } on http.ClientException {
      throw const RegistrationException(
        'Could not reach the server. Check your connection and try again.',
      );
    }

    final Object? body;
    try {
      body = jsonDecode(response.body);
    } on FormatException {
      throw RegistrationException(
        'Unexpected response from the server (${response.statusCode}).',
      );
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        body is Map<String, dynamic>) {
      return RegisteredUser.fromJson(body);
    }

    // DummyJSON reports failures as `{"message": "..."}`.
    final message = body is Map<String, dynamic> ? body['message'] : null;
    throw RegistrationException(
      message is String
          ? message
          : 'Registration failed (${response.statusCode}). Please try again.',
    );
  }

  void close() => _client.close();
}
