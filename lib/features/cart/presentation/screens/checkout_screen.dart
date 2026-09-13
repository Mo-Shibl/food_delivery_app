import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/core/networking/api_result.dart';
import 'package:food_delivery_app/core/routing/app_routes.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/food_delivery_scaffold.dart';
import '../../../orders/domain/entities/master_order.dart';
import '../../../orders/domain/repositories/orders_repository.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/screens/order_details_screen.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController =
  TextEditingController();

  bool _isPlacingOrder = false;

  // Change these when you have the actual fees from your requirements/API.
  static const double _taxRate = 0.14;
  static const double _deliveryFee = 50.0;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final address = _addressController.text.trim();

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your shipping address.'),
          backgroundColor: AppColors.orangeBase,
        ),
      );
      return;
    }

    final cartState = context.read<CartCubit>().state;

    if (cartState.items.isEmpty) {
      return;
    }

    final restaurantId = cartState.items.first.restaurantID;
    final cartLines = cartState.items;

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final repository = GetIt.I<OrdersRepository>();

      final result = await repository.placeOrder(
        restaurantId,
        cartLines,
      );

      if (!mounted) return;

      if (result is ApiSuccess<MasterOrder>) {
        final order = result.data;

        // Clear cart after successful order.
        context.read<CartCubit>().clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => getIt<OrdersCubit>(),
              child: OrderDetailsScreen(
                masterId: order.masterID,
                grandTotal: order.grandtotal,
              ),
            ),
          ),
        );
      } else if (result is ApiFailure<MasterOrder>) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: AppColors.orangeBase,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  void _increaseQuantity(
      BuildContext context,
      String itemName,
      int quantity,
      ) {
    context.read<CartCubit>().updateQuantity(
      itemName,
      quantity + 1,
    );
  }

  void _decreaseQuantity(
      BuildContext context,
      String itemName,
      int quantity,
      ) {
    if (quantity > 1) {
      context.read<CartCubit>().updateQuantity(
        itemName,
        quantity - 1,
      );
    } else {
      context.read<CartCubit>().removeItem(itemName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final date =
        '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';

    final time =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    return FoodDeliveryScaffold(
      backgroundColor: AppColors.yellowBase,
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

          // Confirm Order
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Confirm Order',
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
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (state.items.isEmpty) {
                    return const Center(
                      child: Text('Your cart is empty.'),
                    );
                  }

                  final subtotal = state.items.fold<double>(
                    0,
                        (sum, item) =>
                    sum + (item.itemPrice * item.quantity),
                  );

                  final tax = subtotal * _taxRate;
                  final total =
                      subtotal + tax + _deliveryFee;

                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      35,
                      30,
                      35,
                      80,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // Shipping Address
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.orangeBase,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Shipping Address',
                              style:
                              AppTextStyles.title.copyWith(
                                color: AppColors.font,
                                fontSize: 20,
                              ),
                            ),


                          ],
                        ),

                        const SizedBox(height: 10),

                        // Address field
                        TextField(
                          style: AppTextStyles.textField,

                          controller: _addressController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Enter your shipping address',
                            hintStyle: AppTextStyles.paragraph,
                            filled: true,
                            fillColor: AppColors.yellow2,
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(13),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Order Summary title
                        Row(
                          children: [
                            Text(
                              'Order Summary',
                              style:
                              AppTextStyles.title.copyWith(
                                color: AppColors.font,
                                fontSize: 20,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Edit',
                                style:
                                AppTextStyles.paragraph.copyWith(
                                  color: AppColors.orangeBase,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Date and time
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: AppColors.orangeBase,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              date,
                              style:
                              AppTextStyles.paragraph.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                            const SizedBox(width: 18),
                            const Icon(
                              Icons.access_time_outlined,
                              size: 16,
                              color: AppColors.orangeBase,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              time,
                              style:
                              AppTextStyles.paragraph.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // Order items
                        ...state.items.map(
                              (item) {
                            return Padding(
                              padding:
                              const EdgeInsets.only(bottom: 15),
                              child: Container(
                                padding:
                                const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow2,
                                  borderRadius:
                                  BorderRadius.circular(13),
                                ),
                                child: Row(
                                  children: [
                                    // Item name + price
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.itemName,
                                            style: AppTextStyles
                                                .paragraph
                                                .copyWith(
                                              color:
                                              AppColors.font,
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '${item.itemPrice.toStringAsFixed(2)}',
                                            style: AppTextStyles
                                                .paragraph
                                                .copyWith(
                                              color: AppColors
                                                  .text2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // -
                                    IconButton(
                                      onPressed: () {
                                        _decreaseQuantity(
                                          context,
                                          item.itemName,
                                          item.quantity,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color:
                                        AppColors.orangeBase,
                                      ),
                                    ),

                                    Text(
                                      '${item.quantity}',
                                      style: AppTextStyles.paragraph
                                          .copyWith(
                                        color: AppColors.font,
                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                    ),

                                    // +
                                    IconButton(
                                      onPressed: () {
                                        _increaseQuantity(
                                          context,
                                          item.itemName,
                                          item.quantity,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color:
                                        AppColors.orangeBase,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const Divider(),

                        const SizedBox(height: 10),

                        // Subtotal
                        _priceRow(
                          'Subtotal',
                          subtotal,
                        ),

                        const SizedBox(height: 10),

                        // Tax
                        _priceRow(
                          'Tax',
                          tax,
                        ),

                        const SizedBox(height: 10),

                        // Delivery
                        _priceRow(
                          'Delivery Fee',
                          _deliveryFee,
                        ),

                        const SizedBox(height: 15),

                        const Divider(),

                        const SizedBox(height: 10),

                        // Total
                        _priceRow(
                          'Total',
                          total,
                          isTotal: true,
                        ),

                        const SizedBox(height: 25),

                        // Place Order
                        if (_isPlacingOrder)
                          const SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: Loader(),
                          )
                        else
                          Center(
                            child: PrimaryButton(
                              text: 'Place Order',
                              onPressed: _placeOrder,
                            ),)
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
      String title,
      double price, {
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.paragraph.copyWith(
            color: AppColors.font,
            fontWeight:
            isTotal ? FontWeight.w700 : FontWeight.w400,
            fontSize: isTotal ? 18 : 15,
          ),
        ),
        Text(
          price.toStringAsFixed(2),
          style: AppTextStyles.paragraph.copyWith(
            color: AppColors.font,
            fontWeight:
            isTotal ? FontWeight.w700 : FontWeight.w500,
            fontSize: isTotal ? 18 : 15,
          ),
        ),
      ],
    );
  }
}
