// lib/features/orders/presentation/screens/orders_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_view.dart';

/// TODO: implement per PDF §4.5 — GET /api/Order?apikey={usercode}
/// listing master orders, with an empty state for new users.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(
      title: 'Orders',
      icon: Icons.receipt_long_rounded,
    );
  }
}