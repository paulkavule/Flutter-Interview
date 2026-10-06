import 'dart:convert';

import 'package:http/http.dart' as http;

class RegistrationService {
  RegistrationService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static final _url = Uri.parse('https://dummyjson.com/users/add');

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await _client.post(
      _url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Request failed with status ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
