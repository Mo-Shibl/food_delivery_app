import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant.dart';
import '../../../menu/domain/entities/menu_item.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchSuccess extends SearchState {
  final List<Restaurant> restaurants;
  final List<MenuItem> dishes;
  final String query;

  const SearchSuccess({
    required this.restaurants,
    required this.dishes,
    required this.query,
  });

  @override
  List<Object?> get props => [restaurants, dishes, query];

  SearchSuccess copyWith({
    List<Restaurant>? restaurants,
    List<MenuItem>? dishes,
    String? query,
  }) {
    return SearchSuccess(
      restaurants: restaurants ?? this.restaurants,
      dishes: dishes ?? this.dishes,
      query: query ?? this.query,
    );
  }
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchEmpty extends SearchState {
  const SearchEmpty();
}