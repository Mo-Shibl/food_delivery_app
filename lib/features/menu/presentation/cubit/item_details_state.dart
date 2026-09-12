import '../../domain/entities/menu_item.dart';

class ItemDetailsState {
  final int quantity;
  final MenuItem? item;
  final String? error;
  final bool isLoading;
  final bool isAddedToCart;
  final bool isFavorite;

  const ItemDetailsState({
    this.quantity = 1,
    this.item,
    this.error,
    this.isLoading = false,
    this.isAddedToCart = false,
    this.isFavorite = false,
  });

  ItemDetailsState copyWith({
    int? quantity,
    MenuItem? item,
    String? error,
    bool? isLoading,
    bool? isAddedToCart,
    bool? isFavorite,
  }) {
    return ItemDetailsState(
      quantity: quantity ?? this.quantity,
      item: item ?? this.item,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
