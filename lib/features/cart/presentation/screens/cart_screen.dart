import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/core/routing/app_routes.dart';
import 'package:food_delivery_app/core/themes/app_colors.dart';
import 'package:food_delivery_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_delivery_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_delivery_app/features/cart/domain/entities/cart_line.dart';
import 'package:food_delivery_app/core/widgets/primary_button.dart';
import 'package:food_delivery_app/features/cart/presentation/screens/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 320,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.orangeBase,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(85),
            bottomLeft: Radius.circular(85),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/cart.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.orangeBase,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Cart',
                      style: TextStyle(
                        fontFamily: 'League Spartan',
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Divider(color: AppColors.yellow2, thickness: 1),
                ),
                const SizedBox(height: 10),

                if (state.items.isEmpty)
                  _buildEmptyState(context)
                else
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'You have ${state.items.length} items in the cart',
                            style: const TextStyle(
                              fontFamily: 'League Spartan',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: state.items.length,
                            itemBuilder: (context, index) {
                              return _buildCartItem(context, state.items[index]);
                            },
                          ),
                        ),
                        _buildTotals(context, state),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 60),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/Plus.svg',
                  width: 60,
                  height: 60,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          const Text(
            'Want To Add\nSomething?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartLine item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: item.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: item.imageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: Colors.white24,
                        child: const Icon(Icons.fastfood, color: Colors.white),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.itemName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'League Spartan',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            '29/11/24\n15:00',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'League Spartan',
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(), // Pushes the next row up closer to title if possible, or stays at bottom
                      // Moving price and quantity blocks closer to the title
                      Transform.translate(
                        offset: const Offset(0, -10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.itemPrice.toStringAsFixed(2)} EGP',
                              style: const TextStyle(
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                color: AppColors.yellow2,
                              ),
                            ),
                            _buildStepper(context, item),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Thicker dividing line after each dish
        Divider(
          color: AppColors.yellow2.withValues(alpha: 0.4),
          thickness: 1.5,
          height: 1,
        ),
      ],
    );
  }

  Widget _buildStepper(BuildContext context, CartLine item) {
    final cubit = context.read<CartCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => cubit.updateQuantity(item.itemName, item.quantity - 1),
          child: const Icon(Icons.remove_circle, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          '${item.quantity}',
          style: const TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => cubit.updateQuantity(item.itemName, item.quantity + 1),
          child: const Icon(Icons.add_circle, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildTotals(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          _buildTotalRow('Subtotal', '${state.subtotal.toStringAsFixed(2)} EGP'),
          const SizedBox(height: 12),
          _buildTotalRow('Tax and Fees', '${state.tax.toStringAsFixed(2)} EGP'),
          const SizedBox(height: 12),
          _buildTotalRow('Delivery', '${state.delivery.toStringAsFixed(2)} EGP'),
          const SizedBox(height: 20),
          _buildDashedDivider(),
          const SizedBox(height: 20),
          _buildTotalRow('Total', '${state.total.toStringAsFixed(2)} EGP', isTotal: true),
          const SizedBox(height: 20),
          _buildCheckoutButton(context),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return Row(
      children: List.generate(
        40,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : AppColors.yellow2.withValues(alpha: 0.5),
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return GestureDetector(
    onTap: () {
  Navigator.pushNamed(
  context,
  AppRoutes.checkout,
);
},
      child: Container(
        width: 160,
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.yellowBase,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.orangeBase,
          ),
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'League Spartan',
            fontSize: isTotal ? 22 : 18,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'League Spartan',
            fontSize: isTotal ? 22 : 18,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
