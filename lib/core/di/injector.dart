import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../networking/dio_factory.dart';
import '../../features/restaurants/data/repositories/restaurant_repository_impl.dart';
import '../../features/restaurants/data/services/restaurant_remote_service.dart';
import '../../features/restaurants/domain/repositories/restaurant_repository.dart';
import '../../features/restaurants/presentation/cubit/home_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<Dio>(
    () => createDio(),
  );

  getIt.registerLazySingleton<RestaurantRemoteService>(
    () => RestaurantRemoteService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(getIt<RestaurantRemoteService>()),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<RestaurantRepository>()),
  );
}
