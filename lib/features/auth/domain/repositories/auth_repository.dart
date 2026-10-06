import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? companyName,
  });
}
