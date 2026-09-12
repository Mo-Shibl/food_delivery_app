import '../../domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.itemID,
    required super.itemName,
    required super.itemDescription,
    required super.itemPrice,
    required super.imageUrl,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      itemID: json['itemID'] as int,
      itemName: json['itemName'] as String,
      itemDescription: json['itemDescription'] as String,
      itemPrice: (json['itemPrice'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemID': itemID,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'imageUrl': imageUrl,
    };
  }
}