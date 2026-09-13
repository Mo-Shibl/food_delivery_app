import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Future<void> _confirmCancelOrder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel order'),
          content: const Text(
            'Are you sure you want to cancel this whole order?',
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
      final success = await context.read<OrdersCubit>().cancelMasterOrder(
            widget.masterId,
          );

      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.masterId}'),
        actions: [
          IconButton(
            onPressed: _confirmCancelOrder,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrderDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is OrderDetailsError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is OrderDetailsSuccess) {
            if (state.lines.isEmpty) {
              return const Center(
                child: Text('No items in this order.'),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.lines.length,
                    itemBuilder: (context, index) {
                      final line = state.lines[index];

                      return ListTile(
                        title: Text(line.itemName),
                        subtitle: Text(
                          'Qty: ${line.quantity}   '
                          'Price: ${line.itemPrice.toStringAsFixed(2)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              line.totalPrice.toStringAsFixed(2),
                            ),
                            IconButton(
                              onPressed: () {
                                _confirmDeleteLine(line.orderID);
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Grand Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.grandTotal.toStringAsFixed(2),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}