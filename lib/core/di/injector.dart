import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../networking/dio_factory.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<Dio>(
        () => createDio(),
  );

  // Example:
  // registerAuthFeature(getIt);
  // registerRestaurantsFeature(getIt);
  // registerMenuFeature(getIt);
}