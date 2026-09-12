import 'package:food_delivery_app/core/networking/api_result.dart';
import 'package:food_delivery_app/core/networking/safe_api_call.dart';
import 'package:food_delivery_app/features/restaurants/domain/entities/restaurant.dart';
import 'package:food_delivery_app/features/restaurants/domain/entities/menu_item.dart';
import 'package:food_delivery_app/features/restaurants/domain/repositories/restaurant_repository.dart';
import 'package:food_delivery_app/features/restaurants/data/services/restaurant_remote_service.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteService remoteService;

  RestaurantRepositoryImpl(this.remoteService);

  @override
  Future<ApiResult<List<Restaurant>>> getAllRestaurants() {
    return safeApiCall<List<Restaurant>>(() => remoteService.getRestaurants());
  }

  @override
  Future<ApiResult<List<Restaurant>>> getRestaurantsByCategory(String type) {
    return safeApiCall<List<Restaurant>>(
        () => remoteService.getRestaurantsByCategory(type));
  }

  @override
  Future<ApiResult<List<Restaurant>>> searchRestaurants({
    String? name,
    String? address,
  }) {
    return safeApiCall<List<Restaurant>>(
      () => remoteService.searchRestaurants(name: name, address: address),
    );
  }

  @override
  Future<ApiResult<Restaurant>> getRestaurantById(int id) {
    return safeApiCall<Restaurant>(() => remoteService.getRestaurantById(id));
  }

  @override
  Future<ApiResult<List<MenuItem>>> getRestaurantMenu(int id,
      {String? sortByPrice}) {
    return safeApiCall<List<MenuItem>>(
        () => remoteService.getMenuForRestaurant(id, sortByPrice: sortByPrice));
  }
}
