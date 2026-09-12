import 'package:food_delivery_app/core/networking/api_result.dart';
import 'package:food_delivery_app/features/restaurants/domain/entities/restaurant.dart';
import 'package:food_delivery_app/features/restaurants/domain/entities/menu_item.dart';

abstract class RestaurantRepository {
  Future<ApiResult<List<Restaurant>>> getAllRestaurants();

  Future<ApiResult<List<Restaurant>>> getRestaurantsByCategory(String type);

  Future<ApiResult<List<Restaurant>>> searchRestaurants({
    String? name,
    String? address,
  });

  Future<ApiResult<Restaurant>> getRestaurantById(int id);

  Future<ApiResult<List<MenuItem>>> getRestaurantMenu(int id,
      {String? sortByPrice});
}
