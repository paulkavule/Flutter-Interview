import 'package:product_search/data/services/api_service.dart';

class AuthRepository {
  final _api = ApiService();

  Future<Map<String, dynamic>> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
    Map<String, dynamic> company,
  ) async {
    return await _api.registerUser(
      firstName,
      lastName,
      email,
      password,
      company,
    );
  }
}
