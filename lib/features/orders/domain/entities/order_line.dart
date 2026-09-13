class OrderLine {
  final int orderID;
  final String userID;
  final String itemName;
  final int quantity;
  final double itemPrice;
  final double totalPrice;
  final int masterID;

  const OrderLine({
    required this.orderID,
    required this.userID,
    required this.itemName,
    required this.quantity,
    required this.itemPrice,
    required this.totalPrice,
    required this.masterID,
  });
}