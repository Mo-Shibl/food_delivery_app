import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/food_delivery_scaffold.dart';
import '../../domain/entities/restaurant.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/restaurant_card.dart';
import 'package:food_delivery_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_delivery_app/features/cart/presentation/cubit/cart_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return FoodDeliveryScaffold(
      backgroundColor: AppColors.yellowBase,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.font2,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  onTap: () => Navigator.pushNamed(context, AppRoutes.search),
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 11,
                                    color: AppColors.font,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                      fontFamily: 'League Spartan',
                                      fontSize: 11,
                                      color: AppColors.font.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, AppRoutes.search),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: AppColors.orangeBase,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.tune,
                                    size: 12,
                                    color: AppColors.font2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _buildHeaderIconBox(
                                iconPath: 'assets/icons/cart.svg',
                                iconWidth: 16,
                                iconHeight: 16,
                                onTap: () {
                                  FoodDeliveryScaffold.of(context)?.openCartDrawer();
                                },
                              ),
                              if (state.items.isNotEmpty)
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      '${state.items.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildHeaderIconBox(
                        iconPath: 'assets/icons/notification.svg',
                        iconWidth: 14,
                        iconHeight: 20,
                      ),
                      const SizedBox(width: 8),
                      _buildHeaderIconBox(
                        iconPath: 'assets/icons/profile.svg',
                        iconWidth: 12,
                        iconHeight: 18,
                        onTap: () {
                          FoodDeliveryScaffold.of(context)?.openProfileDrawer();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Good Morning',
                    style: TextStyle(
                      fontFamily: 'League Spartan',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      color: AppColors.font2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Rise and shine! It's breakfast time",
                    style: TextStyle(
                      fontFamily: 'League Spartan',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      color: AppColors.orangeBase,
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.font2,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: RefreshIndicator(
                  color: AppColors.orangeBase,
                  onRefresh: () => context.read<HomeCubit>().refresh(),
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.orangeBase,
                          ),
                        );
                      }
                      if (state is HomeError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.message,
                                style: const TextStyle(
                                  fontFamily: 'League Spartan',
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.orangeBase,
                                ),
                                onPressed: () => context
                                    .read<HomeCubit>()
                                    .loadRestaurants(),
                                child: const Text(
                                  'Retry',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final List<Restaurant> allRestaurants =
                          state is HomeSuccess ? state.restaurants : [];
                      final String? selectedCategory = state is HomeSuccess
                          ? state.selectedCategory
                          : null;
                      final List<String> liveCategories =
                          state is HomeSuccess ? state.categories : [];

                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 25.0,
                          bottom: 80.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 105,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: liveCategories.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 14),
                                itemBuilder: (context, index) {
                                  final category = liveCategories[index];
                                  return _buildCategoryItem(
                                    label: category,
                                    icon: _iconForCategory(category),
                                    isSelected:
                                        selectedCategory == category,
                                    onTap: () => _handleCategoryTap(
                                      context,
                                      category,
                                      selectedCategory,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Divider(
                              color: Color(0xFFFFD8C7),
                              thickness: 1,
                              height: 1,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              selectedCategory ?? 'All Restaurants',
                              style: const TextStyle(
                                fontFamily: 'League Spartan',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                height: 1.0,
                                color: AppColors.font,
                              ),
                            ),
                            const SizedBox(height: 14),
                            if (allRestaurants.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: Text(
                                    'No restaurants available',
                                    style: TextStyle(
                                      fontFamily: 'League Spartan',
                                      fontSize: 12,
                                      color: AppColors.font,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...allRestaurants.map(
                                (restaurant) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  child: RestaurantCard(
                                    restaurant: restaurant,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCategoryTap(
    BuildContext context,
    String category,
    String? currentSelected,
  ) {
    if (currentSelected == category) {
      context.read<HomeCubit>().loadRestaurants();
    } else {
      context.read<HomeCubit>().filterByCategory(category);
    }
  }

  IconData _iconForCategory(String category) {
    final key = category.toLowerCase();
    if (key.contains('biryani') || key.contains('rice')) {
      return Icons.rice_bowl_outlined;
    }
    if (key.contains('seafood')) {
      return Icons.set_meal_outlined;
    }
    if (key.contains('dessert') || key.contains('sweet')) {
      return Icons.icecream_outlined;
    }
    if (key.contains('drink') || key.contains('brewery')) {
      return Icons.local_drink_outlined;
    }
    if (key.contains('vegan') || key.contains('veg')) {
      return Icons.eco_outlined;
    }
    if (key.contains('fine dining')) {
      return Icons.dinner_dining_outlined;
    }
    return Icons.restaurant_menu_outlined;
  }

  Widget _buildHeaderIconBox({
    required String iconPath,
    required double iconWidth,
    required double iconHeight,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.font2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: iconWidth,
            height: iconHeight,
            colorFilter: const ColorFilter.mode(
              AppColors.orangeBase,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required String label,
    required IconData icon,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    final formattedLabel = label.replaceAll(' ', '\n');
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 49),
            height: 62,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.orangeBase : AppColors.yellow2,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? AppColors.font2 : AppColors.orangeBase,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formattedLabel,
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.1,
              color: AppColors.font,
            ),
          ),
        ],
      ),
    );
  }
}
