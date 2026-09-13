import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../networking/dio_factory.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/services/auth_remote_service.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

import '../../features/restaurants/data/repositories/restaurant_repository_impl.dart';
import '../../features/restaurants/data/services/restaurant_remote_service.dart';
import '../../features/restaurants/domain/repositories/restaurant_repository.dart';
import '../../features/restaurants/presentation/cubit/home_cubit.dart';
import '../../features/restaurants/presentation/cubit/restaurant_details_cubit.dart';
import '../../features/restaurants/presentation/cubit/search_cubit.dart';

import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/data/services/profile_remote_service.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

import '../../features/menu/data/repositories/menu_repository_impl.dart';
import '../../features/menu/data/services/menu_remote_service.dart';
import '../../features/menu/domain/repositories/menu_repository.dart';
import '../../features/menu/presentation/cubit/item_details_cubit.dart';
import '../../features/menu/presentation/cubit/menu_cubit.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';

import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/data/services/orders_remote_service.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';

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

  // Restaurants Remote Service
  getIt.registerLazySingleton<RestaurantRemoteService>(
        () => RestaurantRemoteService(getIt<Dio>()),
  );

  // Restaurants Repository
  getIt.registerLazySingleton<RestaurantRepository>(
        () => RestaurantRepositoryImpl(
      getIt<RestaurantRemoteService>(),
    ),
  );

  // Home Cubit
  getIt.registerFactory<HomeCubit>(
        () => HomeCubit(
      getIt<RestaurantRepository>(),
    ),
  );

  // Restaurant Details Cubit
  getIt.registerFactory<RestaurantDetailsCubit>(
    () => RestaurantDetailsCubit(
      getIt<RestaurantRepository>(),
    ),
  );

  // Search Cubit
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(
      restaurantRepository: getIt<RestaurantRepository>(),
      menuRepository: getIt<MenuRepository>(),
    ),
  );

  getIt.registerLazySingleton<ProfileRemoteService>(
        () => ProfileRemoteService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(getIt<ProfileRemoteService>()),
  );

  getIt.registerFactory<ProfileCubit>(
        () => ProfileCubit(getIt<ProfileRepository>()),
  );

  // Menu Remote Service
  getIt.registerLazySingleton<MenuRemoteService>(
    () => MenuRemoteService(getIt<Dio>()),
  );

  // Menu Repository
  getIt.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(
      getIt<MenuRemoteService>(),
    ),
  );

  // Item Details Cubit
  getIt.registerFactory<ItemDetailsCubit>(
    () => ItemDetailsCubit(),
  );

  // Menu Cubit
  getIt.registerFactory<MenuCubit>(
    () => MenuCubit(getIt<MenuRepository>()),
  );

  // Cart Cubit
  getIt.registerLazySingleton<CartCubit>(
    () => CartCubit(),
  );

  // Orders Remote Service
  getIt.registerLazySingleton<OrdersRemoteService>(
    () => OrdersRemoteService(getIt<Dio>()),
  );

  // Orders Repository
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(getIt<OrdersRemoteService>()),
  );

  // Orders Cubit
  getIt.registerFactory<OrdersCubit>(
    () => OrdersCubit(getIt<OrdersRepository>()),
  );
}
