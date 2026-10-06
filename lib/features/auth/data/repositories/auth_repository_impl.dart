import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/register_request_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? companyName,
  }) async {
    try {
      final request = RegisterRequestDto(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        company: companyName != null ? CompanyDto(name: companyName) : null,
      );
      final response = await remoteDataSource.register(request);
      return Right(
        User(
          id: response.id,
          firstName: response.firstName,
          email: response.email,
        ),
      );
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
