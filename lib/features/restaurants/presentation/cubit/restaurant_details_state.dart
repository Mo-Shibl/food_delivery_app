import '../../domain/entities/restaurant.dart';
import '../../domain/entities/menu_item.dart';

sealed class RestaurantDetailsState {
  const RestaurantDetailsState();
}

class RestaurantDetailsInitial extends RestaurantDetailsState {
  const RestaurantDetailsInitial();
}

class RestaurantDetailsLoading extends RestaurantDetailsState {
  const RestaurantDetailsLoading();
}

class RestaurantDetailsSuccess extends RestaurantDetailsState {
  final Restaurant restaurant;
  final List<MenuItem> menu;
  final String? sortByPrice;

  const RestaurantDetailsSuccess({
    required this.restaurant,
    required this.menu,
    this.sortByPrice,
  });

  RestaurantDetailsSuccess copyWith({
    Restaurant? restaurant,
    List<MenuItem>? menu,
    String? sortByPrice,
  }) {
    return RestaurantDetailsSuccess(
      restaurant: restaurant ?? this.restaurant,
      menu: menu ?? this.menu,
      sortByPrice: sortByPrice ?? this.sortByPrice,
    );
  }
}

class RestaurantDetailsError extends RestaurantDetailsState {
  final String message;
  const RestaurantDetailsError(this.message);
}
