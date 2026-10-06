import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/register_user.dart';

part 'register_provider.g.dart';

@riverpod
Dio dio(DioRef ref) => Dio();

@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) =>
    AuthRemoteDataSource(ref.watch(dioProvider));

@riverpod
AuthRepositoryImpl authRepository(AuthRepositoryRef ref) =>
    AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));

@riverpod
RegisterUser registerUser(RegisterUserRef ref) =>
    RegisterUser(ref.watch(authRepositoryProvider));

@riverpod
class RegisterForm extends _$RegisterForm {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? companyName,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(registerUserProvider)
        .call(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          companyName: companyName,
        );
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (user) => const AsyncData(null),
    );
  }
}
