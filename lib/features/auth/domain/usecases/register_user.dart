import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;
  RegisterUser(this.repository);

  Future<Either<Failure, User>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? companyName,
  }) {
    return repository.registerUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      companyName: companyName,
    );
  }
}
