import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/food_delivery_scaffold.dart';
import '../../domain/entities/menu_item.dart';
import '../cubit/item_details_cubit.dart';
import '../cubit/item_details_state.dart';
import 'package:food_delivery_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_delivery_app/features/cart/presentation/cubit/cart_state.dart';

class ItemDetailsScreen extends StatelessWidget {
  final MenuItem menuItem;

  const ItemDetailsScreen({
    super.key,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ItemDetailsCubit>()..setItem(menuItem),
      child: FoodDeliveryScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.font),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    state.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: state.isFavorite ? AppColors.orangeBase : AppColors.font,
                  ),
                  onPressed: () => context.read<ItemDetailsCubit>().toggleFavorite(),
                );
              },
            ),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ItemDetailsCubit, ItemDetailsState>(
              listener: (context, state) {
                // local UI feedback if needed
              },
            ),
            BlocListener<CartCubit, CartState>(
              listenWhen: (previous, current) =>
                  !previous.showReplaceConfirm && current.showReplaceConfirm,
              listener: (context, state) {
                _showReplaceCartDialog(context);
              },
            ),
          ],
          child: BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: CachedNetworkImage(
                          imageUrl: menuItem.imageUrl,
                          height: 280,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 280,
                            color: AppColors.yellow2,
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 280,
                            color: AppColors.yellow2,
                            child: const Icon(Icons.error, size: 50, color: AppColors.orangeBase),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Price and Stepper Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${menuItem.itemPrice.toStringAsFixed(0)} EGP',
                            style: AppTextStyles.title.copyWith(
                              color: AppColors.orangeBase,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildStepper(context),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    const Divider(color: Color(0xFFE8E8E8), thickness: 1),
                    const SizedBox(height: 16),

                    // Name
                    Text(
                      menuItem.itemName,
                      style: AppTextStyles.subtitulo.copyWith(
                        color: AppColors.font,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      menuItem.itemDescription,
                      style: AppTextStyles.paragraph.copyWith(
                        color: AppColors.font.withValues(alpha: 0.7),
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Add to Cart Button
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          context.read<CartCubit>().addItem(menuItem, state.quantity);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to cart')),
                          );
                        },
                        child: Container(
                          width: 207,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.orangeBase,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Bag.svg',
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 110),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showReplaceCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.font2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text(
          'Replace Cart?',
          style: TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.font,
          ),
        ),
        content: const Text(
          'Adding items from this restaurant will clear your current cart. Continue?',
          style: TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 16,
            color: AppColors.font,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<CartCubit>().cancelReplaceCart();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel', style: TextStyle(color: AppColors.hint)),
          ),
          TextButton(
            onPressed: () {
              context.read<CartCubit>().confirmReplaceCart();
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart replaced and item added')),
              );
            },
            child: const Text('Replace', style: TextStyle(color: AppColors.orangeBase)),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(BuildContext context) {
    final cubit = context.read<ItemDetailsCubit>();
    final quantity = context.select((ItemDetailsCubit c) => c.state.quantity);

    return Row(
      children: [
        GestureDetector(
          onTap: quantity > 1 ? cubit.decrementQuantity : null,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: quantity > 1 ? AppColors.orangeBase : AppColors.orange2,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.remove, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '$quantity',
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: cubit.incrementQuantity,
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.orangeBase,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
