import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../../../../core/networking/api_result.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final RestaurantRepository repository;

  HomeCubit(this.repository) : super(const HomeInitial());

  Future<void> loadRestaurants() async {
    emit(const HomeLoading());

    try {
      final result = await repository.getAllRestaurants();

      if (result is ApiSuccess<List<Restaurant>>) {
        final restaurants = result.data;

        emit(
          HomeSuccess(
            restaurants: restaurants,
            categories: _getCategories(restaurants),
          ),
        );
      } else if (result is ApiFailure<List<Restaurant>>) {
        emit(HomeError(result.message));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> filterByCategory(String category) async {
    emit(const HomeLoading());

    try {
      final result =
      await repository.getRestaurantsByCategory(category);

      if (result is ApiSuccess<List<Restaurant>>) {
        final restaurants = result.data;

        final currentState = state;

        final categories = currentState is HomeSuccess
            ? currentState.categories
            : _getCategories(restaurants);

        emit(
          HomeSuccess(
            restaurants: restaurants,
            categories: categories,
            selectedCategory: category,
          ),
        );
      } else if (result is ApiFailure<List<Restaurant>>) {
        emit(HomeError(result.message));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> refresh() async {
    try {
      final result = await repository.getAllRestaurants();

      if (result is ApiSuccess<List<Restaurant>>) {
        final restaurants = result.data;

        emit(
          HomeSuccess(
            restaurants: restaurants,
            categories: _getCategories(restaurants),
          ),
        );
      } else if (result is ApiFailure<List<Restaurant>>) {
        emit(HomeError(result.message));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  List<String> _getCategories(List<Restaurant> restaurants) {
    return restaurants
        .map((restaurant) => restaurant.type.trim())
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList();
  }
}