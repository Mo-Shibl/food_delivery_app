import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/routing/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: 'assets/images/onboarding_1.png',
      icon: Icons.receipt_long_outlined,
      title: 'Order For Food',
    ),
    OnboardingData(
      image: 'assets/images/onboarding_2.png',
      icon: Icons.credit_card_outlined,
      title: 'Easy Payment',
    ),
    OnboardingData(
      image: 'assets/images/onboarding_3.png',
      icon: Icons.delivery_dining_outlined,
      title: 'Fast Delivery',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skip() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellowBase,
      body: Stack(
        children: [
          // Food image
          Positioned(
            top:30,
            left: 0,
            right: 0,
             height: 484,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return SizedBox(
                  width: double.infinity,
                 height: double.infinity,

                  child: Image.asset(
                    _pages[index].image,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
      
          // Skip
          Positioned(
            top: 32,
            right: 18,
            child: GestureDetector(
              onTap: _skip,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Skip',
                    style: AppTextStyles.paragraph.copyWith(
                      color: AppColors.orangeBase,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.orangeBase,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
      
          // White bottom container
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 338,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.font2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 14,
                ),
                child: Column(
                  children: [
                    // Page icon
                    Icon(
                      _pages[_currentPage].icon,
                      color: AppColors.orangeBase,
                      size: 40,
                    ),
      
                    const SizedBox(height: 10),
      
                    // Title
                    Text(
                      _pages[_currentPage].title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.orangeBase,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
      
                    const SizedBox(height: 18),
      
                    // Description
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur\n '
                      'adipiscing elit, sed do eiusmod tempor\n '
                      'incididunt ut labore et dolore magna.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.tituloScreen.copyWith(
                        color: AppColors.font,
                        fontSize: 15,
                        height: 1.1,
                      ),
                    ),
      
                    const SizedBox(height: 18),
      
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) {
                          final isActive = index == _currentPage;
      
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 2,
                            ),
                            width: 13,
                            height: 2,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.orangeBase
                                  : AppColors.yellow2,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        },
                      ),
                    ),
      
                  const   SizedBox(height: 18),
      
                    // Next / Get Started
                    SizedBox(
                      width: 133,
                      height: 30,
                      child: ElevatedButton(
                       
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                        
      
                          backgroundColor: AppColors.orangeBase,
                          foregroundColor: AppColors.font2,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: AppTextStyles.subtitulo.copyWith(
                            color: AppColors.font2,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
      
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final IconData icon;
  final String title;

  OnboardingData({
    required this.image,
    required this.icon,
    required this.title,
  });
}