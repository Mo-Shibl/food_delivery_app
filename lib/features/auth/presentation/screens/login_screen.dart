import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/core/routing/app_router.dart';
import 'package:food_delivery_app/core/routing/app_routes.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    context.read<AuthCubit>().login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.home,
    (route) => false,
  );
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.orangeBase,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: AppColors.yellowBase,
            body: Stack(
              children: [
                // Back button
                Positioned(
                  top: 20,
                  left: 20,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      color: AppColors.orangeBase,
                    ),
                  ),
                ),
            
                
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Hello!',
                      style: AppTextStyles.tituloScreen.copyWith(
                        color: AppColors.font2,
                      ),
                    ),
                  ),
                ),
            
                // White login container
                Positioned(
                  top: 161,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.font2,
                
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
            
                         Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.font,
                ),
              ),
            ),
            
                          const SizedBox(height: 35),
            
                          // Email
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: AppTextStyles.subtitulo.copyWith(
                                color: AppColors.font,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
            
                          const SizedBox(height: 8),
            
                          AppTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
            
                          const SizedBox(height: 20),
            
                          // Password
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: AppTextStyles.subtitulo.copyWith(
                                color: AppColors.font,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
            
                          const SizedBox(height: 8),
            
                          AppTextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.font,
                              ),
                            ),
                          ),
            
                         
            
                 
                          const SizedBox(height: 55),
            
                          // Login button
                          if (isLoading)
                            const SizedBox(
                              height: 45,
                              child: Loader(),
                            )
                          else
                            PrimaryButton(
                              text: 'Login',
                              onPressed : () => _login(context),
                            ),
            
                          const SizedBox(height: 25),
            
                          // Sign up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: AppTextStyles.paragraph.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.signup,
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  style: AppTextStyles.paragraph.copyWith(
                                    color: AppColors.orangeBase,
                        
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

