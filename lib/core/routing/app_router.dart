import 'package:flutter/material.dart';

import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _comingSoonRoute('Splash');

      case AppRoutes.login:
        return _comingSoonRoute('Login');

      case AppRoutes.signup:
        return _comingSoonRoute('Signup');

      case AppRoutes.home:
        return _comingSoonRoute('Home');

      case AppRoutes.restaurantDetails:
        return _comingSoonRoute('Restaurant Details');

      case AppRoutes.search:
        return _comingSoonRoute('Search');

      case AppRoutes.itemDetails:
        return _comingSoonRoute('Item Details');

      case AppRoutes.cart:
        return _comingSoonRoute('Cart');

      case AppRoutes.checkout:
        return _comingSoonRoute('Checkout');

      case AppRoutes.orders:
        return _comingSoonRoute('Orders');

      case AppRoutes.orderDetails:
        return _comingSoonRoute('Order Details');

      case AppRoutes.profile:
        return _comingSoonRoute('Profile');

      default:
        return _comingSoonRoute('Unknown Route');
    }
  }

  static MaterialPageRoute<dynamic> _comingSoonRoute(String screenName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(screenName),
        ),
        body: Center(
          child: Text(
            '$screenName\nComing soon',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}