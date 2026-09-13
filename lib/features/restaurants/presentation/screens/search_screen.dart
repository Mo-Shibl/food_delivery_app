import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/widgets/food_delivery_scaffold.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/restaurant_card.dart';
import '../../../menu/domain/entities/menu_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: FoodDeliveryScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.font),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Search',
            style: AppTextStyles.tituloScreen.copyWith(color: AppColors.font),
          ),
        ),
        body: Builder(
          builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (query) {
                              context.read<SearchCubit>().onSearchQueryChanged(query);
                            },
                            style: const TextStyle(fontFamily: 'League Spartan'),
                            decoration: InputDecoration(
                              hintText: 'Search for restaurants or dishes...',
                              hintStyle: TextStyle(
                                fontFamily: 'League Spartan',
                                color: AppColors.font.withValues(alpha: 0.5),
                              ),
                              prefixIcon: const Icon(Icons.search, color: AppColors.orangeBase),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state is SearchInitial) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search, size: 80, color: AppColors.orange2),
                              SizedBox(height: 16),
                              Text(
                                'What are you looking for?',
                                style: TextStyle(
                                  fontFamily: 'League Spartan',
                                  fontSize: 18,
                                  color: AppColors.hint,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is SearchLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppColors.orangeBase),
                        );
                      }

                      if (state is SearchError) {
                        return Center(child: Text(state.message));
                      }

                      if (state is SearchEmpty) {
                        return const Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(
                              fontFamily: 'League Spartan',
                              fontSize: 18,
                              color: AppColors.hint,
                            ),
                          ),
                        );
                      }

                      if (state is SearchSuccess) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 80),
                          child: _buildResults(context, state),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, SearchSuccess state) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        if (state.restaurants.isNotEmpty) ...[
          Text(
            'Restaurants',
            style: AppTextStyles.subtitulo.copyWith(color: AppColors.font),
          ),
          const SizedBox(height: 12),
          ...state.restaurants.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RestaurantCard(restaurant: r),
          )),
          const SizedBox(height: 24),
        ],
        if (state.dishes.isNotEmpty) ...[
          Text(
            'Dishes',
            style: AppTextStyles.subtitulo.copyWith(color: AppColors.font),
          ),
          const SizedBox(height: 12),
          ...state.dishes.map((item) => _buildDishItem(context, item)),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildDishItem(BuildContext context, MenuItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: item.imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: AppColors.yellow2),
            errorWidget: (context, url, error) => const Icon(Icons.fastfood),
          ),
        ),
        title: Text(
          item.itemName,
          style: AppTextStyles.subtitulo.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.restaurantName,
              style: AppTextStyles.paragraph.copyWith(color: AppColors.orangeBase),
            ),
            const SizedBox(height: 4),
            Text(
              '${item.itemPrice.toStringAsFixed(0)} EGP',
              style: AppTextStyles.subtitulo.copyWith(color: AppColors.font, fontSize: 16),
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.itemDetails,
            arguments: item,
          );
        },
      ),
    );
  }
}