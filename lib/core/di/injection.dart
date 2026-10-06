import 'package:get_it/get_it.dart';

import '../../features/registration/data/datasources/registration_remote_data_source.dart';
import '../../features/registration/data/repositories/registration_repository_impl.dart';
import '../../features/registration/domain/repositories/registration_repository.dart';
import '../../features/registration/domain/usecases/register_user.dart';
import '../../features/registration/presentation/bloc/registration_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

void initDependencies() {
  sl.registerLazySingleton(buildDio);
  sl.registerLazySingleton<RegistrationRemoteDataSource>(
    () => RegistrationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RegistrationRepository>(
    () => RegistrationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerFactory(() => RegistrationBloc(registerUser: sl()));
}
