import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/registered_user.dart';
import '../entities/registration_details.dart';
import '../repositories/registration_repository.dart';

class RegisterUser implements UseCase<RegisteredUser, RegistrationDetails> {
  const RegisterUser(this._repository);
  final RegistrationRepository _repository;

  @override
  Future<Either<Failure, RegisteredUser>> call(RegistrationDetails params) =>
      _repository.register(params);
}
