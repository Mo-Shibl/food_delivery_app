class Restaurant {
  final int restaurantID;
  final String restaurantName;
  final String address;
  final String type;
  final bool parkingLot;

  const Restaurant({
    required this.restaurantID,
    required this.restaurantName,
    required this.address,
    required this.type,
    required this.parkingLot,
  });
}