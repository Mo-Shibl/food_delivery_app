import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/routing/app_routes.dart';
import '../../domain/entities/menu_item.dart';
import '../cubit/menu_cubit.dart';
import '../cubit/menu_state.dart';

class MenuSearchScreen extends StatefulWidget {
  const MenuSearchScreen({super.key});

  @override
  State<MenuSearchScreen> createState() => _MenuSearchScreenState();
}

class _MenuSearchScreenState extends State<MenuSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      return;
    }

    context.read<MenuCubit>().searchItems(query);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MenuCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Search',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: 'Search for a dish...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _search,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: BlocBuilder<MenuCubit, MenuState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.error != null) {
                    return Center(
                      child: Text(
                        state.error!,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (state.items.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No dishes found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];

                      return _buildDishItem(item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildDishItem(MenuItem item)
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: item.imageUrl,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 70,
              height: 70,
              color: AppColors.yellow2,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 70,
              height: 70,
              color: AppColors.yellow2,
              child: const Icon(
                Icons.fastfood,
                color: AppColors.orangeBase,
              ),
            ),
          ),
        ),
        title: Text(
          item.itemName,
          style: AppTextStyles.subtitulo.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.font,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.restaurantName,
              style: AppTextStyles.paragraph.copyWith(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${item.itemPrice.toStringAsFixed(0)} EGP',
              style: AppTextStyles.subtitulo.copyWith(
                color: AppColors.orangeBase,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
       onTap: () {
  Navigator.pushNamed(
    context,
    AppRoutes.restaurantDetails,
    arguments: item.restaurantID,
  );
},
      ),
    );
  }
}