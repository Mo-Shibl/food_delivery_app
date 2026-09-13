class MasterOrder {
  final int masterID;
  final int userID;
  final String usercode;
  final int restaurantID;
  final double grandtotal;

  const MasterOrder({
    required this.masterID,
    required this.userID,
    required this.usercode,
    required this.restaurantID,
    required this.grandtotal,
  });
}