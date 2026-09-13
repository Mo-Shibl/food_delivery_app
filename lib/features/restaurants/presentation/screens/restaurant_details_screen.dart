import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../cubit/restaurant_details_cubit.dart';
import '../cubit/restaurant_details_state.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/menu_item.dart';
import '../../../../features/menu/domain/entities/menu_item.dart' as menu_feature;
import '../../../../core/routing/app_routes.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final int restaurantId;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantDetailsCubit>().loadRestaurantDetails(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
        builder: (context, state) {
          if (state is RestaurantDetailsLoading) {
            return const Loader();
          }

          if (state is RestaurantDetailsError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context
                  .read<RestaurantDetailsCubit>()
                  .loadRestaurantDetails(widget.restaurantId),
            );
          }

          if (state is RestaurantDetailsSuccess) {
            return _buildContent(state.restaurant, state.menu);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(Restaurant restaurant, List<MenuItem> menu) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppColors.orangeBase,
              child: const Center(
                child: Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        restaurant.restaurantName,
                        style: AppTextStyles.title.copyWith(fontSize: 28),
                      ),
                    ),
                    if (restaurant.parkingLot)
                      const Icon(
                        Icons.local_parking,
                        color: AppColors.orangeBase,
                        size: 24,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  restaurant.type,
                  style: AppTextStyles.subtitulo.copyWith(
                    color: AppColors.orangeBase,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        restaurant.address,
                        style: AppTextStyles.paragraph.copyWith(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu',
                      style: AppTextStyles.title.copyWith(fontSize: 22),
                    ),
                    BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
                      builder: (context, state) {
                        if (state is RestaurantDetailsSuccess) {
                          return PopupMenuButton<String>(
                            icon: Icon(
                              Icons.sort,
                              color: state.sortByPrice != null
                                  ? AppColors.orangeBase
                                  : Colors.grey,
                            ),
                            onSelected: (value) {
                              context.read<RestaurantDetailsCubit>().sortByPrice(
                                    restaurant.restaurantID,
                                    value,
                                  );
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'asc',
                                child: Text('Price: Low to High'),
                              ),
                              const PopupMenuItem(
                                value: 'desc',
                                child: Text('Price: High to Low'),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        if (menu.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateView(message: 'No menu items available'),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = menu[index];
                return _buildMenuItem(item, restaurant);
              },
              childCount: menu.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item, Restaurant restaurant) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.itemDetails,
        arguments: menu_feature.MenuItem(
          itemID: item.itemID,
          itemName: item.itemName,
          itemDescription: item.itemDescription,
          itemPrice: item.itemPrice,
          restaurantName: restaurant.restaurantName,
          restaurantID: restaurant.restaurantID,
          imageUrl: item.imageUrl,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.yellow2,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.orangeBase,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.yellow2,
                  child: const Icon(Icons.fastfood, color: AppColors.orangeBase),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style: AppTextStyles.subtitulo.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.font,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.itemDescription,
                    style: AppTextStyles.paragraph.copyWith(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.itemPrice.toStringAsFixed(0)} EGP',
                    style: AppTextStyles.subtitulo.copyWith(
                      fontSize: 14,
                      color: AppColors.orangeBase,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}