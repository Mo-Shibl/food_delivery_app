import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../services/restaurant_remote_service.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteService remoteService;

  RestaurantRepositoryImpl(this.remoteService);

  @override
  Future<ApiResult<List<Restaurant>>> getAllRestaurants() {
    return safeApiCall(() => remoteService.getRestaurants());
  }

  @override
  Future<ApiResult<List<Restaurant>>> getRestaurantsByCategory(String type) {
    return safeApiCall(() => remoteService.getRestaurantsByCategory(type));
  }

  @override
  Future<ApiResult<List<Restaurant>>> searchRestaurants({
    String? name,
    String? address,
  }) {
    return safeApiCall(
          () => remoteService.searchRestaurants(name: name, address: address),
    );
  }

  @override
  Future<ApiResult<Restaurant>> getRestaurantById(int id) {
    return safeApiCall(() => remoteService.getRestaurantById(id));
  }
}