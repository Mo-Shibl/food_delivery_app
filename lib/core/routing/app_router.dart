import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/auth/presentation/screens/home_screen.dart';
import 'package:food_delivery_app/features/auth/presentation/screens/login_screen.dart';
import 'package:food_delivery_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:food_delivery_app/features/auth/presentation/screens/splash_screen.dart';

import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
         return MaterialPageRoute(
    builder: (_) => const SplashScreen(),
  );

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());


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
    default: return MaterialPageRoute( builder: (_) => const LoginScreen(), );
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

