import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/registered_user.dart';
import '../../domain/entities/registration_details.dart';
import '../../domain/repositories/registration_repository.dart';
import '../datasources/registration_remote_data_source.dart';
import '../models/registration_request_model.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  const RegistrationRepositoryImpl(this.remote);

  final RegistrationRemoteDataSource remote;

  @override
  Future<Either<Failure, RegisteredUser>> register(
    RegistrationDetails details,
  ) async {
    try {
      final user = await remote.register(RegistrationRequestModel(details));
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
