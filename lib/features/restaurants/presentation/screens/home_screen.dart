import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../domain/entities/restaurant.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

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
    return Scaffold(
      backgroundColor: AppColors.yellowBase,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Layer 1 & 2: Header + Main White Container
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header & Greetings Section ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Header: Search Bar + 3 Icon Boxes
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
                                          color: AppColors.font.withValues(alpha: 0.5),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
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
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          _buildHeaderIconBox(
                            iconPath: 'assets/icons/cart.svg',
                            iconWidth: 16,
                            iconHeight: 16,
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
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Greetings
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

                // Layer 2: White Main Content Container
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

                          // Get original or filtered restaurants
                          final List<Restaurant> allRestaurants = state is HomeSuccess
                              ? state.restaurants
                              : [];
                          final String? selectedCategory = state is HomeSuccess
                              ? state.selectedCategory
                              : null;

                          // Apply safe filtering
                          final List<Restaurant> displayedRestaurants = (selectedCategory != null && selectedCategory.isNotEmpty)
                              ? allRestaurants.where((r) => r.type.toLowerCase().contains(selectedCategory.toLowerCase())).toList()
                              : allRestaurants;

                          // Fallback to all restaurants if category filtering returned empty
                          final List<Restaurant> finalRestaurantsList = displayedRestaurants.isNotEmpty
                              ? displayedRestaurants
                              : allRestaurants;

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
                                // Categories Row
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildCategoryItem(
                                      label: 'Snacks',
                                      iconPath: 'assets/icons/Snacks.svg',
                                      iconWidth: 32.81,
                                      iconHeight: 37.0,
                                      isSelected: selectedCategory == 'Snacks',
                                      onTap: () => _handleCategoryTap(context, 'Snacks', selectedCategory),
                                    ),
                                    _buildCategoryItem(
                                      label: 'Meals',
                                      iconPath: 'assets/icons/Meals.svg',
                                      iconWidth: 17.34,
                                      iconHeight: 37.0,
                                      isSelected: selectedCategory == 'Meals',
                                      onTap: () => _handleCategoryTap(context, 'Meals', selectedCategory),
                                    ),
                                    _buildCategoryItem(
                                      label: 'Vegan',
                                      iconPath: 'assets/icons/Vegan.svg',
                                      iconWidth: 37.0,
                                      iconHeight: 37.0,
                                      isSelected: selectedCategory == 'Vegan',
                                      onTap: () => _handleCategoryTap(context, 'Vegan', selectedCategory),
                                    ),
                                    _buildCategoryItem(
                                      label: 'Dessert',
                                      iconPath: 'assets/icons/Desserts.svg',
                                      iconWidth: 29.82,
                                      iconHeight: 37.0,
                                      isSelected: selectedCategory == 'Dessert',
                                      onTap: () => _handleCategoryTap(context, 'Dessert', selectedCategory),
                                    ),
                                    _buildCategoryItem(
                                      label: 'Drinks',
                                      iconPath: 'assets/icons/Drinks.svg',
                                      iconWidth: 21.14,
                                      iconHeight: 37.0,
                                      isSelected: selectedCategory == 'Drinks',
                                      onTap: () => _handleCategoryTap(context, 'Drinks', selectedCategory),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Divider Line
                                const Divider(
                                  color: Color(0xFFFFD8C7),
                                  thickness: 1,
                                  height: 1,
                                ),

                                const SizedBox(height: 14),

                                // --- Best Seller Section Header ---
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Best Seller',
                                      style: TextStyle(
                                        fontFamily: 'League Spartan',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        height: 1.0,
                                        color: AppColors.font,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => context.read<HomeCubit>().loadRestaurants(),
                                      child: const Row(
                                        children: [
                                          Text(
                                            'View All',
                                            style: TextStyle(
                                              fontFamily: 'League Spartan',
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              height: 1.0,
                                              color: AppColors.orangeBase,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          RotatedBox(
                                            quarterTurns: 2,
                                            child: Icon(
                                              Icons.arrow_back_ios_new,
                                              size: 10,
                                              color: AppColors.orangeBase,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                // --- Best Seller Horizontal List ---
                                SizedBox(
                                  height: 108,
                                  child: finalRestaurantsList.isEmpty
                                      ? const Center(
                                    child: Text(
                                      'No restaurants available',
                                      style: TextStyle(
                                        fontFamily: 'League Spartan',
                                        fontSize: 12,
                                        color: AppColors.font,
                                      ),
                                    ),
                                  )
                                      : ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: finalRestaurantsList.length,
                                    separatorBuilder: (context, index) =>
                                    const SizedBox(width: 11.3),
                                    itemBuilder: (context, index) {
                                      final restaurant = finalRestaurantsList[index];
                                      return _buildBestSellerCard(
                                        title: restaurant.restaurantName,
                                        price: restaurant.parkingLot ? 'Free P' : 'Parking',
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(height: 25),

                                // --- Recommend Section Header ---
                                const Text(
                                  'Recommend',
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    height: 1.0,
                                    color: AppColors.font,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // --- Recommend Horizontal List ---
                                SizedBox(
                                  height: 140,
                                  child: finalRestaurantsList.isEmpty
                                      ? const Center(
                                    child: Text(
                                      'No recommended restaurants',
                                      style: TextStyle(
                                        fontFamily: 'League Spartan',
                                        fontSize: 12,
                                        color: AppColors.font,
                                      ),
                                    ),
                                  )
                                      : ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: finalRestaurantsList.length,
                                    separatorBuilder: (context, index) =>
                                    const SizedBox(width: 15),
                                    itemBuilder: (context, index) {
                                      final restaurant = finalRestaurantsList[index];
                                      return _buildRecommendCard(
                                        title: restaurant.restaurantName,
                                        type: restaurant.type,
                                        rating: '5.0',
                                        isFavorite: false,
                                      );
                                    },
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

            // Layer 3: Orange Base Bottom Footer Container
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 61,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: AppColors.orangeBase,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Home.svg',
                      width: 25,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                        AppColors.font2,
                        BlendMode.srcIn,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/Food.svg',
                      width: 31,
                      height: 21,
                      colorFilter: const ColorFilter.mode(
                        AppColors.font2,
                        BlendMode.srcIn,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/Fav.svg',
                      width: 21,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        AppColors.font2,
                        BlendMode.srcIn,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/Menu.svg',
                      width: 21,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        AppColors.font2,
                        BlendMode.srcIn,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/CustomerService.svg',
                      width: 25,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.font2,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCategoryTap(BuildContext context, String category, String? currentSelected) {
    if (currentSelected == category) {
      context.read<HomeCubit>().loadRestaurants();
    } else {
      context.read<HomeCubit>().filterByCategory(category);
    }
  }

  // --- Recommend Card ---
  Widget _buildRecommendCard({
    required String title,
    required String type,
    required String rating,
    bool isFavorite = false,
  }) {
    return Container(
      width: 159,
      height: 140,
      padding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.yellow2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.restaurant,
                color: AppColors.orangeBase,
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'League Spartan',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.font,
                ),
              ),
              Text(
                type,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'League Spartan',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.orangeBase,
                ),
              ),
            ],
          ),

          // Rating Badge
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 16,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: AppColors.font2,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    rating,
                    style: const TextStyle(
                      fontFamily: 'League Spartan',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF391713),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.star_rounded,
                    size: 10,
                    color: Color(0xFFF4BA1B),
                  ),
                ],
              ),
            ),
          ),

          // Favorites Button
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: AppColors.font2,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                  size: 11,
                  color: AppColors.orangeBase,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Best Seller Card ---
  Widget _buildBestSellerCard({
    required String title,
    required String price,
  }) {
    return Container(
      width: 80,
      height: 108,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.yellow2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.fastfood,
                  color: AppColors.orangeBase,
                  size: 24,
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'League Spartan',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.font,
                  ),
                ),
              ],
            ),
          ),

          // Price / Parking Tag
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.orangeBase,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                price,
                style: const TextStyle(
                  fontFamily: 'League Spartan',
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: AppColors.font2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconBox({
    required String iconPath,
    required double iconWidth,
    required double iconHeight,
  }) {
    return Container(
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
    );
  }

  Widget _buildCategoryItem({
    required String label,
    required String iconPath,
    required double iconWidth,
    required double iconHeight,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 49,
            height: 62,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.orangeBase : AppColors.yellow2,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: iconWidth,
                height: iconHeight,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.font2 : AppColors.orangeBase,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 49,
            height: 11,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'League Spartan',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                height: 1.0,
                color: isSelected ? AppColors.orangeBase : AppColors.font,
              ),
            ),
          ),
        ],
      ),
    );
  }
}