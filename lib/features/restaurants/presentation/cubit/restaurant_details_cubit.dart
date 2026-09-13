import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/api_result.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/restaurant_repository.dart';
import 'restaurant_details_state.dart';

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  final RestaurantRepository repository;

  RestaurantDetailsCubit(this.repository) : super(const RestaurantDetailsInitial());

  Future<void> loadRestaurantDetails(int restaurantID, {String? sortByPrice}) async {
    emit(const RestaurantDetailsLoading());

    try {
      final restaurantResult = await repository.getRestaurantById(restaurantID);
      final menuResult = await repository.getRestaurantMenu(restaurantID, sortByPrice: sortByPrice);

      if (restaurantResult is ApiSuccess<Restaurant> &&
          menuResult is ApiSuccess<List<MenuItem>>) {
        emit(
          RestaurantDetailsSuccess(
            restaurant: restaurantResult.data,
            menu: menuResult.data,
            sortByPrice: sortByPrice,
          ),
        );
      } else {
        String errorMessage = 'Failed to load details';
        if (restaurantResult is ApiFailure<Restaurant>) {
          errorMessage = restaurantResult.message;
        } else if (menuResult is ApiFailure<List<MenuItem>>) {
          errorMessage = menuResult.message;
        }
        emit(RestaurantDetailsError(errorMessage));
      }
    } catch (e) {
      emit(RestaurantDetailsError(e.toString()));
    }
  }

  Future<void> sortByPrice(int restaurantID, String direction) async {
    // We could just call loadRestaurantDetails, but maybe we only want to reload the menu?
    // The current implementation of loadRestaurantDetails reloads both. 
    // Given the state structure, it's easier to just call it again with the parameter.
    await loadRestaurantDetails(restaurantID, sortByPrice: direction);
  }
}