import '../../domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.restaurantID,
    required super.restaurantName,
    required super.address,
    required super.type,
    required super.parkingLot,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      restaurantID: json['restaurantID'] as int,
      restaurantName: json['restaurantName'] as String,
      address: json['address'] as String,
      type: json['type'] as String,
      parkingLot: json['parkingLot'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantID': restaurantID,
      'restaurantName': restaurantName,
      'address': address,
      'type': type,
      'parkingLot': parkingLot,
    };
  }
}