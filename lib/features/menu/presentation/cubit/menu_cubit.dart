import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/core/networking/api_result.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository repository;

  MenuCubit(this.repository) : super(const MenuState());
  Future<void> getAllItems() async {
    emit(state.copyWith(isLoading: true, error: null)); //1

    final result = await repository.getAllItems();

    if (result is ApiSuccess<List<MenuItem>>) {
      emit(state.copyWith(items: result.data, isLoading: false));
    } else if (result is ApiFailure<List<MenuItem>>) {
      emit(state.copyWith(isLoading: false, error: result.message));
    }
  }

  // Future<void> getMenuForRestaurant(int restaurantId, {String? sort}) async {
  //   emit(state.copyWith(isLoading: true, error: null, sort: sort));

  //   try {
  //     final items = await repository.getMenuForRestaurant(
  //       restaurantId,
  //       sort: sort,
  //     );

  //     emit(state.copyWith(items: items, isLoading: false));
  //   } catch (e) {
  //     emit(state.copyWith(isLoading: false, error: e.toString()));
  //   }
  // }

  // Future<void> sortByPrice(int restaurantId, bool ascending) async {
  //   final sort = ascending ? 'asc' : 'desc';

  //   await getMenuForRestaurant(restaurantId, sort: sort);
  // }

  // Future<void> searchItems(String itemName, {String? sort}) async {
  //   emit(state.copyWith(isLoading: true, error: null, sort: sort));

  //   try {
  //     final items = await repository.searchItems(itemName, sort: sort);

  //     emit(state.copyWith(items: items, isLoading: false));
  //   } catch (e) {
  //     emit(state.copyWith(isLoading: false, error: e.toString()));
  //   }
  // }

  Future<void> searchItems(String query) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await repository.searchItems(query);
    if (result is ApiSuccess<List<MenuItem>>) {
      emit(state.copyWith(items: result.data, isLoading: false));
    } else if (result is ApiFailure<List<MenuItem>>) {
      emit(state.copyWith(isLoading: false, error: result.message));
    }
  }

  Future<void> sortByPrice(bool ascending) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await repository.sortItemsByPrice(ascending);
    if (result is ApiSuccess<List<MenuItem>>) {
      emit(state.copyWith(items: result.data, isLoading: false));
    } else if (result is ApiFailure<List<MenuItem>>) {
      emit(state.copyWith(isLoading: false, error: result.message));
    }
  }
}
