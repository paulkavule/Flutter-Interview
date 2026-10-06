import '../../data/models/registration_payload.dart';
import '../repositories/i_registration_repository.dart';

class RegisterUser {
  final IRegistrationRepository _repository;

  const RegisterUser(this._repository);

  Future<Map<String, dynamic>> call(RegistrationPayload payload) {
    return _repository.registerUser(payload);
  }
}
