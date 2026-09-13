import '../../domain/entities/cart_line.dart';

class CartState {
  final List<CartLine> items;
  final bool showReplaceConfirm;
  final CartLine? pendingItem;

  const CartState({
    this.items = const [],
    this.showReplaceConfirm = false,
    this.pendingItem,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get tax => 5.0; // Static per design spec
  double get delivery => 3.0; // Static per design spec
  double get total => items.isEmpty ? 0 : subtotal + tax + delivery;

  CartState copyWith({
    List<CartLine>? items,
    bool? showReplaceConfirm,
    CartLine? pendingItem,
  }) {
    return CartState(
      items: items ?? this.items,
      showReplaceConfirm: showReplaceConfirm ?? this.showReplaceConfirm,
      pendingItem: pendingItem ?? this.pendingItem,
    );
  }
}
