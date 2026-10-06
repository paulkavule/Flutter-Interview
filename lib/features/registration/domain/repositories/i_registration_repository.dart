import '../../data/models/registration_payload.dart';

abstract class IRegistrationRepository {
  Future<Map<String, dynamic>> registerUser(RegistrationPayload payload);
}
