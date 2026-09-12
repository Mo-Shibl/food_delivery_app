import '../../domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.itemID,
    required super.itemName,
    required super.itemDescription,
    required super.itemPrice,
    required super.restaurantName,
    required super.restaurantID,
    required super.imageUrl,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    String rawImageUrl = json['imageUrl'] ?? '';
    // URL-encode spaces in the path
    String encodedImageUrl = rawImageUrl.replaceAll(' ', '%20');

    return MenuItemModel(
      itemID: json['itemID'],
      itemName: json['itemName'],
      itemDescription: json['itemDescription'],
      itemPrice: (json['itemPrice'] as num).toDouble(),
      restaurantName: json['restaurantName'],
      restaurantID: json['restaurantID'],
      imageUrl: encodedImageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemID': itemID,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'restaurantName': restaurantName,
      'restaurantID': restaurantID,
      'imageUrl': imageUrl,
    };
  }
}
