import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>()..checkSession(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSessionLoaded) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
             (route) => false,
            );
            
          }

          if (state is AuthNoSession) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.login,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.yellowBase,
          body: Center(
            child: Image.asset(
              'assets/images/Group 270.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}


