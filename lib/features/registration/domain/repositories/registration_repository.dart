import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/registered_user.dart';
import '../entities/registration_details.dart';

abstract interface class RegistrationRepository {
  Future<Either<Failure, RegisteredUser>> register(RegistrationDetails details);
}
