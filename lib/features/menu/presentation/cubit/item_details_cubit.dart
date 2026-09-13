import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/menu_item.dart';
import 'item_details_state.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
  ItemDetailsCubit() : super(const ItemDetailsState());

  void setItem(MenuItem item) {
    emit(state.copyWith(item: item));
  }

  void incrementQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void toggleFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  // addToCart logic moved to UI to interact with CartCubit directly
}
