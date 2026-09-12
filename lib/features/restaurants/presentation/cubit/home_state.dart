import '../../domain/entities/restaurant.dart';

sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeSuccess extends HomeState {
  final List<Restaurant> restaurants;
  final List<String> categories;
  final String? selectedCategory;

  const HomeSuccess({
    required this.restaurants,
    required this.categories,
    this.selectedCategory,
  });
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}