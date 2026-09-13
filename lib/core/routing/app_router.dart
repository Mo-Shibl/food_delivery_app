import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/features/auth/presentation/screens/home_screen.dart';

import 'package:food_delivery_app/features/auth/presentation/screens/login_screen.dart';
import 'package:food_delivery_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:food_delivery_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:food_delivery_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:food_delivery_app/features/cart/presentation/screens/checkout_screen.dart';
import 'package:food_delivery_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:food_delivery_app/features/orders/presentation/screens/order_details_screen.dart';
import 'package:food_delivery_app/features/orders/presentation/screens/orders_screen.dart';

import '../../core/di/injector.dart';
import '../../features/restaurants/presentation/cubit/home_cubit.dart';
import '../../features/restaurants/presentation/cubit/restaurant_details_cubit.dart';
import '../../features/restaurants/presentation/screens/home_screen.dart'
    as restaurants;
import '../../features/restaurants/presentation/screens/profile_screen.dart';
import '../../features/restaurants/presentation/screens/restaurant_details_screen.dart';
import '../../features/restaurants/presentation/screens/search_screen.dart';
import '../../features/menu/domain/entities/menu_item.dart';
import '../../features/menu/presentation/screens/item_details_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<HomeCubit>(),
            child: const restaurants.HomeScreen(),
          ),
        );


      case AppRoutes.restaurantDetails:
        final restaurantId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<RestaurantDetailsCubit>(),
            child: RestaurantDetailsScreen(restaurantId: restaurantId),
          ),
        );

      case AppRoutes.search:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );

      case AppRoutes.itemDetails:
        final menuItem = settings.arguments as MenuItem;
        return MaterialPageRoute(
          builder: (_) => ItemDetailsScreen(menuItem: menuItem),
        );

      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case AppRoutes.checkout:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<OrdersCubit>(),
            child: const CheckoutScreen(),
          ),
        );

      case AppRoutes.orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());

      case AppRoutes.orderDetails:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<OrdersCubit>(),
            child: OrderDetailsScreen(
              masterId: args['masterId'],
              grandTotal: args['grandTotal'],
            ),
          ),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }

  static MaterialPageRoute<dynamic> _comingSoonRoute(String screenName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text(screenName)),
        body: Center(
          child: Text('$screenName\nComing soon', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
