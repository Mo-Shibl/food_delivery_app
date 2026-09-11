import '../entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getAllRestaurants();

  Future<List<Restaurant>> getRestaurantsByCategory(String type);

  Future<List<Restaurant>> searchRestaurants({
    String? name,
    String? address,
  });

  Future<Restaurant> getRestaurantById(int id);
}