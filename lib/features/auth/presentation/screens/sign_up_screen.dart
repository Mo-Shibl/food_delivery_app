import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/core/routing/app_routes.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dateOfBirthController =
  TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _signUp(BuildContext context) {
    context.read<AuthCubit>().register(
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  Future<void> _selectDateOfBirth() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _dateOfBirthController.text =
        '${selectedDate.day.toString().padLeft(2, '0')}/'
            '${selectedDate.month.toString().padLeft(2, '0')}/'
            '${selectedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully.'),
              ),
            );

            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
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
            resizeToAvoidBottomInset: true,
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

                // New Account
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'New Account',
                      style: AppTextStyles.tituloScreen.copyWith(
                        color: AppColors.font2,
                      ),
                    ),
                  ),
                ),

                // White container
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
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 35,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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

                          const SizedBox(height: 15),

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

                          const SizedBox(height: 15),

                          // Confirm Password
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Confirm Password',
                              style: AppTextStyles.subtitulo.copyWith(
                                color: AppColors.font,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          AppTextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.font,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Mobile Number
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Mobile Number',
                              style: AppTextStyles.subtitulo.copyWith(
                                color: AppColors.font,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          AppTextField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 15),

                          // Date of birth
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Date of birth',
                              style: AppTextStyles.subtitulo.copyWith(
                                color: AppColors.font,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          GestureDetector(
                            onTap: _selectDateOfBirth,
                            child: AbsorbPointer(
                              child: AppTextField(
                                controller: _dateOfBirthController,
                                suffixIcon: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppColors.font,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Terms and privacy
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Text.rich(
                              TextSpan(
                                text: 'By continuing, you agree to \n',
                                style: AppTextStyles.paragraph.copyWith(
                                  color: AppColors.font,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms of Use',
                                    style: AppTextStyles.paragraph.copyWith(
                                      color: AppColors.orangeBase,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' and ',
                                    style: AppTextStyles.paragraph.copyWith(
                                      color: AppColors.font,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy.',
                                    style: AppTextStyles.paragraph.copyWith(
                                      color: AppColors.orangeBase,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Sign Up button
                          if (isLoading)
                            const SizedBox(
                              height: 45,
                              child: Loader(),
                            )
                          else
                            PrimaryButton(
                              text: 'Sign Up',
                              onPressed: () => _signUp(context),
                            ),

                          const SizedBox(height: 16),

                          // Login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: AppTextStyles.paragraph.copyWith(
                                  color: AppColors.font,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.login,
                                        (route) => false,
                                  );
                                },
                                child: Text(
                                  'Log In',
                                  style: AppTextStyles.paragraph.copyWith(
                                    color: AppColors.orangeBase,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
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