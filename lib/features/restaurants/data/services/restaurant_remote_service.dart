import 'package:dio/dio.dart';

import '../models/restaurant_model.dart';

class RestaurantRemoteService {
  final Dio dio;

  RestaurantRemoteService(this.dio);

  Future<List<RestaurantModel>> getRestaurants() async {
    final response = await dio.get('/api/Restaurant');

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map(
          (json) => RestaurantModel.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  Future<List<RestaurantModel>> getRestaurantsByCategory(
      String category,
      ) async {
    final response = await dio.get(
      '/api/Restaurant',
      queryParameters: {
        'category': category,
      },
    );

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map(
          (json) => RestaurantModel.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  Future<RestaurantModel> getRestaurantById(int id) async {
    final response = await dio.get('/api/Restaurant/$id');

    return RestaurantModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<List<RestaurantModel>> searchRestaurants({
    String? name,
    String? address,
  }) async {
    final Map<String, dynamic> queryParameters = {};

    if (name != null && name.isNotEmpty) {
      queryParameters['name'] = name;
    }

    if (address != null && address.isNotEmpty) {
      queryParameters['address'] = address;
    }

    final response = await dio.get(
      '/api/Restaurant',
      queryParameters: queryParameters,
    );

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map(
          (json) => RestaurantModel.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}