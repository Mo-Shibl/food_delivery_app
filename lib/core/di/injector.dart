import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../networking/dio_factory.dart';
import '../../features/auth/data/services/auth_remote_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';


final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<Dio>(
        () => createDio(),
  );
  
 // Auth Remote Service
  getIt.registerLazySingleton<AuthRemoteService>(
    () => AuthRemoteService(getIt<Dio>()),
  );

  // Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteService>(),
    ),
  );

  // Auth Cubit
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      getIt<AuthRepository>(),
    ),
  );
  // Example:
  // registerAuthFeature(getIt);
  // registerRestaurantsFeature(getIt);
  // registerMenuFeature(getIt);
}