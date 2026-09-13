import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_line.dart';
import '../../../menu/domain/entities/menu_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(MenuItem item, int quantity) {
    final newLine = CartLine(
      itemName: item.itemName,
      quantity: quantity,
      itemPrice: item.itemPrice,
      restaurantID: item.restaurantID,
      imageUrl: item.imageUrl,
    );

    if (state.items.isEmpty || state.items.first.restaurantID == item.restaurantID) {
      _actuallyAddItem(newLine);
    } else {
      emit(state.copyWith(
        showReplaceConfirm: true,
        pendingItem: newLine,
      ));
    }
  }

  void confirmReplaceCart() {
    if (state.pendingItem != null) {
      emit(state.copyWith(
        items: [],
        showReplaceConfirm: false,
      ));
      _actuallyAddItem(state.pendingItem!);
    }
  }

  void cancelReplaceCart() {
    emit(state.copyWith(
      showReplaceConfirm: false,
      pendingItem: null,
    ));
  }

  void _actuallyAddItem(CartLine newLine) {
    final existingIndex = state.items.indexWhere((i) => i.itemName == newLine.itemName);
    List<CartLine> newItems = List.from(state.items);

    if (existingIndex != -1) {
      final existing = newItems[existingIndex];
      newItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + newLine.quantity,
      );
    } else {
      newItems.add(newLine);
    }

    emit(state.copyWith(
      items: newItems,
      pendingItem: null,
      showReplaceConfirm: false,
    ));
  }

  void updateQuantity(String itemName, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemName);
      return;
    }

    final newItems = state.items.map((item) {
      if (item.itemName == itemName) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: newItems));
  }

  void removeItem(String itemName) {
    final newItems = state.items.where((item) => item.itemName != itemName).toList();
    emit(state.copyWith(items: newItems));
  }

  void clear() {
    emit(const CartState());
  }
}
