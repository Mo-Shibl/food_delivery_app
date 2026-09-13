import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/core/networking/api_result.dart';
import 'package:food_delivery_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../orders/domain/entities/master_order.dart';
import '../../../orders/domain/repositories/orders_repository.dart';
import '../../../orders/presentation/screens/order_details_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController =
      TextEditingController();

  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
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

        context.read<CartCubit>().clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<OrdersCubit>(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text('Your cart is empty.'),
            );
          }

          final grandTotal = state.items.fold<double>(
            0,
            (sum, item) => sum + (item.itemPrice * item.quantity),
          );

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      ...state.items.map(
                        (item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.itemName),
                          subtitle: Text(
                            'Qty: ${item.quantity} × '
                            '${item.itemPrice.toStringAsFixed(2)}',
                          ),
                          trailing: Text(
                            (item.itemPrice * item.quantity)
                                .toStringAsFixed(2),
                          ),
                        ),
                      ),

                      const Divider(),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Grand Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            grandTotal.toStringAsFixed(2),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      TextField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Delivery address',
                          filled: true,
                          fillColor: AppColors.yellow2,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: _isPlacingOrder ? null : _placeOrder,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.yellowBase,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: _isPlacingOrder
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Place Order',
                            style: TextStyle(
                              fontFamily: 'League Spartan',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.orangeBase,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}