import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/api_result.dart';
import '../../domain/entities/restaurant.dart';
import '../../../menu/domain/entities/menu_item.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../../../menu/domain/repositories/menu_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final RestaurantRepository restaurantRepository;
  final MenuRepository menuRepository;
  Timer? _debounce;

  SearchCubit({
    required this.restaurantRepository,
    required this.menuRepository,
  }) : super(const SearchInitial());

  void onSearchQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      search(query);
    });
  }

  Future<void> search(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    try {
      final results = await Future.wait([
        restaurantRepository.searchRestaurants(name: trimmedQuery, address: trimmedQuery),
        menuRepository.searchItems(trimmedQuery),
      ]);

      final restaurantResult = results[0] as ApiResult<List<Restaurant>>;
      final dishResult = results[1] as ApiResult<List<MenuItem>>;

      if (restaurantResult is ApiSuccess<List<Restaurant>> &&
          dishResult is ApiSuccess<List<MenuItem>>) {
        final List<Restaurant> restaurants = restaurantResult.data;
        final List<MenuItem> dishes = dishResult.data;

        if (restaurants.isEmpty && dishes.isEmpty) {
          emit(const SearchEmpty());
        } else {
          emit(SearchSuccess(
            restaurants: restaurants,
            dishes: dishes,
            query: trimmedQuery,
          ));
        }
      } else {
        String errorMessage = 'Failed to fetch search results';
        if (restaurantResult is ApiFailure<List<Restaurant>>) {
          errorMessage = restaurantResult.message;
        } else if (dishResult is ApiFailure<List<MenuItem>>) {
          errorMessage = dishResult.message;
        }
        emit(SearchError(errorMessage));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}