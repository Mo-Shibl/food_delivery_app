import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/api_result.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository repository;

  MenuCubit(this.repository) : super(const MenuState());
  Future<void> getAllItems() async {
    emit(state.copyWith(isLoading: true, error: null)); //1

  Future<void> getAllItems() async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await repository.getAllItems();

    if (result is ApiSuccess<List<MenuItem>>) {
      emit(state.copyWith(
        items: result.data,
        isLoading: false,
      ));
    } else if (result is ApiFailure<List<MenuItem>>) {
      emit(state.copyWith(
        isLoading: false,
        error: result.message,
      ));
    }
  }

  Future<void> searchItems(String query) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await repository.searchItems(query);

    if (result is ApiSuccess<List<MenuItem>>) {
      emit(state.copyWith(
        items: result.data,
        isLoading: false,
      ));
    } else if (result is ApiFailure<List<MenuItem>>) {
      emit(state.copyWith(
        isLoading: false,
        error: result.message,
      ));
    }
  }

  Future<void> sortByPrice(bool ascending) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await repository.sortItemsByPrice(ascending);

    if (result is ApiSuccess<List<MenuItem>>) {
      emit(state.copyWith(
        items: result.data,
        isLoading: false,
        sort: ascending ? 'asc' : 'desc',
      ));
    } else if (result is ApiFailure<List<MenuItem>>) {
      emit(state.copyWith(
        isLoading: false,
        error: result.message,
      ));
    }
  }
}
