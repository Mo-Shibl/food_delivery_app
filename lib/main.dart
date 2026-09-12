import 'package:flutter/material.dart';

import 'core/di/injector.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';

void main() {
  setupGetIt();
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}