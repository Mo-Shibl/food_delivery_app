import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/core/widgets/loader.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../domain/entities/menu_item.dart';
import '../cubit/menu_cubit.dart';
import '../cubit/menu_state.dart';

class MenuListScreen extends StatefulWidget {
  final int restaurantId;

  const MenuListScreen({super.key, required this.restaurantId});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<MenuCubit>().getMenuForRestaurant(widget.restaurantId);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MenuCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort),
              onSelected: (value) {
                if (value == 'low') {
                  context.read<MenuCubit>().sortByPrice(true);
                } else {
                  context.read<MenuCubit>().sortByPrice(false);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'low', child: Text('Price: Low to High')),
                PopupMenuItem(value: 'high', child: Text('Price: High to Low')),
              ],
            ),
          ],
        ),
        body: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: Loader());
            }

            if (state.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 50),
                      const SizedBox(height: 12),
                      Text(state.error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MenuCubit>().getAllItems();
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.restaurant_menu, size: 60),
                    SizedBox(height: 12),
                    Text(
                      'No menu items available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = state.items[index];

                return _buildMenuItem(context, item);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl ,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => SizedBox(
                  width: 100,
                  height: 100,
                 // color: Colors.grey.shade200,
                  child: const Center(child: Loader()),
                ),
                errorWidget: (context, url, error) => SizedBox(
                  width: 100,
                  height: 100,
                 // color: Colors.grey.shade200,
                  child: const Icon(Icons.restaurant, size: 40),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Item information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style: AppTextStyles.tituloScreen,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    item.itemDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.itemPrice} EGP',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                  SizedBox(
                    height: 36,
                       child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.itemDetails,
                            arguments: item,
                          );
                        },
                        child: const Text('Add'),
                      ),
                  ),
                    ],
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
