import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/food_delivery_scaffold.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int masterId;
  final double grandTotal;

  const OrderDetailsScreen({
    super.key,
    required this.masterId,
    required this.grandTotal,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().getOrderDetails(widget.masterId);
  }

  String _getItemImageUrl(String name) {
    final lowercaseName = name.toLowerCase();
    if (lowercaseName.contains('strawberry') || lowercaseName.contains('shake')) {
      return 'https://images.unsplash.com/photo-1579954115545-a95591f28bfc?q=80&w=300';
    }
    if (lowercaseName.contains('broccoli') || lowercaseName.contains('lasagna') || lowercaseName.contains('pasta')) {
      return 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?q=80&w=300';
    }
    if (lowercaseName.contains('burger')) {
      return 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=300';
    }
    if (lowercaseName.contains('pizza')) {
      return 'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=300';
    }
    return 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=300';
  }

  Future<void> _confirmDeleteLine(int orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete item'),
          content: const Text(
            'Are you sure you want to delete this item from the order?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await context.read<OrdersCubit>().deleteOrderLine(
            orderId,
            widget.masterId,
          );
    }
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'League Spartan',
              fontSize: isTotal ? 20 : 18,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.font,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'League Spartan',
              fontSize: isTotal ? 20 : 18,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.font,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 4.0;
          const dashHeight = 1.0;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FoodDeliveryScaffold(
      backgroundColor: AppColors.yellowBase,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom Top Header matching PNG
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.orangeBase, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 48.0),
                        child: Text(
                          'Order Details',
                          style: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // White Rounded Body Card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  child: BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (context, state) {
                      if (state is OrderDetailsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppColors.orangeBase),
                        );
                      }

                      if (state is OrderDetailsError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(fontFamily: 'League Spartan', fontSize: 16),
                          ),
                        );
                      }

                      if (state is OrderDetailsSuccess) {
                        final lines = state.lines;
                        final subtotal = lines.fold<double>(0, (sum, line) => sum + line.totalPrice);
                        const taxAndFees = 5.00;
                        const delivery = 3.00;
                        final total = lines.isEmpty ? widget.grandTotal : (subtotal + taxAndFees + delivery);

                        return ListView(
                          padding: const EdgeInsets.fromLTRB(24, 30, 24, 80),
                          children: [
                            // Order Header
                            Text(
                              'Order No. ${widget.masterId.toString().padLeft(7, '0')}',
                              style: const TextStyle(
                                fontFamily: 'League Spartan',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.font,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '29 Nov, 01:20 pm',
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                color: AppColors.hint,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Divider(color: Colors.grey.shade100, thickness: 1.5),
                            const SizedBox(height: 8),

                            if (lines.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 32.0),
                                child: Center(
                                  child: Text(
                                    'No items in this order.',
                                    style: TextStyle(fontFamily: 'League Spartan', fontSize: 16),
                                  ),
                                ),
                              )
                            else
                              ...lines.map((line) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.network(
                                              _getItemImageUrl(line.itemName),
                                              width: 84,
                                              height: 84,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                width: 84,
                                                height: 84,
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
                                                  line.itemName,
                                                  style: const TextStyle(
                                                    fontFamily: 'League Spartan',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.font,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  '\$${line.itemPrice.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontFamily: 'League Spartan',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.font,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                '29/11/24\n15:00',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: 'League Spartan',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.font,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => _confirmDeleteLine(line.orderID),
                                                    child: const Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                                                      child: Text(
                                                        '–',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.orangeBase,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                    child: Text(
                                                      '${line.quantity}',
                                                      style: const TextStyle(
                                                        fontFamily: 'League Spartan',
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColors.font,
                                                      ),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                                                    child: Text(
                                                      '+',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.orangeBase,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Divider(color: Colors.grey.shade100, thickness: 1.5),
                                    ],
                                  ),
                                );
                              }),

                            const SizedBox(height: 12),
                            _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                            _buildSummaryRow('Tax and Fees', '\$${taxAndFees.toStringAsFixed(2)}'),
                            _buildSummaryRow('Delivery', '\$${delivery.toStringAsFixed(2)}'),
                            _buildDottedLine(),
                            _buildSummaryRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
                            
                            // Order Again Button
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 24.0, bottom: 20.0),
                                child: SizedBox(
                                  width: 140,
                                  height: 36,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.orange2,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Text(
                                      'Order Again',
                                      style: TextStyle(
                                        fontFamily: 'League Spartan',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.orangeBase,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
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
}
