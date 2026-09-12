// lib/features/restaurants/presentation/screens/search_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_view.dart';

/// TODO: implement per PDF §4.2 — search restaurants by name/address
/// (GET /api/Restaurant?name=&address=) and dishes by itemName
/// (GET /api/Restaurant/items?ItemName=), with sortbyprice support.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(title: 'Search', icon: Icons.search_rounded);
  }
}