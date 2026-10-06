import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://dummyjson.com';
  static const Duration _timeout = Duration(seconds: 15);

  final http.Client _client;

  Future<User> registerUser(User user) async {
    final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse('$_baseUrl/users/add'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(user.toJson()),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const ApiException('The request timed out. Please try again.');
    } on SocketException {
      throw const ApiException(
        'Could not reach the server. Check your connection and try again.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Could not reach the server. Check your connection and try again.',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Registration failed (HTTP ${response.statusCode}). Please try again.',
      );
    }

    final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw const ApiException(
        'Received an unexpected response from the server.',
      );
    }

    return User.fromJson(body);
  }
}
