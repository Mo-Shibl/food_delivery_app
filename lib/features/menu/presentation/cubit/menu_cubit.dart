import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository repository;

  MenuCubit(this.repository) : super(const MenuState());

  Future<void> getMenuForRestaurant(
    int restaurantId, {
    String? sort,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
      sort: sort,
    ));

    try {
      final items = await repository.getMenuForRestaurant(
        restaurantId,
        sort: sort,
      );

      emit(state.copyWith(
        items: items,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> sortByPrice(
    int restaurantId,
    bool ascending,
  ) async {
    final sort = ascending ? 'asc' : 'desc';

    await getMenuForRestaurant(
      restaurantId,
      sort: sort,
    );
  }
  Future<void> searchItems(
  String itemName, {
  String? sort,
}) async {
  emit(state.copyWith(
    isLoading: true,
    error: null,
    sort: sort,
  ));

  try {
    final items = await repository.searchItems(
      itemName,
      sort: sort,
    );

    emit(state.copyWith(
      items: items,
      isLoading: false,
    ));
  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      error: e.toString(),
    ));
  }
}
}