import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersCubit>()..getOrders(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is OrdersError) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is OrdersSuccess) {
              if (state.orders.isEmpty) {
                return const Center(
                  child: Text('You have no orders yet.'),
                );
              }

              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];

                  return ListTile(
                    title: Text(
                      'Order #${order.masterID}',
                    ),
                    subtitle: Text(
                      'Restaurant: ${order.restaurantID}',
                    ),
                    trailing: Text(
                      '${order.grandtotal.toStringAsFixed(2)}',
                    ),
                    onTap: () {
                      Navigator.push(
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
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}