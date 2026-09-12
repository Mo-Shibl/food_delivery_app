import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/widgets/primary_button.dart';
import 'package:food_delivery_app/core/widgets/app_text_field.dart';
import 'package:food_delivery_app/features/auth/presentation/screens/login_screen.dart';
import 'package:food_delivery_app/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:food_delivery_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:food_delivery_app/features/auth/presentation/screens/splash_screen.dart';
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
      //home: const LoginScreen(),
      
     
    );
  }
}