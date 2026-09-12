// lib/core/widgets/main_navigation_screen.dart
import 'package:flutter/material.dart';

import '../../features/restaurants/presentation/screens/home_screen.dart';
import '../../features/restaurants/presentation/screens/search_screen.dart';
import '../../features/restaurants/presentation/screens/orders_screen.dart';
import '../../features/restaurants/presentation/screens/profile_screen.dart';
import '../themes/app_colors.dart';

/// Bottom-nav shell that keeps each tab's state alive via IndexedStack,
/// matching the PDF's "Bottom navigation should keep tab state
/// (IndexedStack or similar)" requirement.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeScreen(),
    const SearchScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  final List<_NavItem> _items = const [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.search_rounded, label: 'Search'),
    _NavItem(icon: Icons.receipt_long_rounded, label: 'Orders'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.orangeBase,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_items.length, (index) {
              final isSelected = index == _currentIndex;
              final item = _items[index];

              return InkWell(
                onTap: () => setState(() => _currentIndex = index),
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        color: isSelected
                            ? AppColors.font2
                            : AppColors.font2.withValues(alpha: 0.5),
                        size: 24,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontFamily: 'League Spartan',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.font2
                              : AppColors.font2.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}