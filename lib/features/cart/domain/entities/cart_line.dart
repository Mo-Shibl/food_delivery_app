class CartLine {
  final String itemName;
  final int quantity;
  final double itemPrice;
  final int restaurantID;
  final String? imageUrl;

  const CartLine({
    required this.itemName,
    required this.quantity,
    required this.itemPrice,
    required this.restaurantID,
    this.imageUrl,
  });

  double get total => itemPrice * quantity;

  CartLine copyWith({
    String? itemName,
    int? quantity,
    double? itemPrice,
    int? restaurantID,
    String? imageUrl,
  }) {
    return CartLine(
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      itemPrice: itemPrice ?? this.itemPrice,
      restaurantID: restaurantID ?? this.restaurantID,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
