import '../../../../core/networking/api_result.dart';
import '../entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<ApiResult<List<Restaurant>>> getAllRestaurants();

  Future<ApiResult<List<Restaurant>>> getRestaurantsByCategory(String type);

  Future<ApiResult<List<Restaurant>>> searchRestaurants({
    String? name,
    String? address,
  });

  Future<ApiResult<Restaurant>> getRestaurantById(int id);
}