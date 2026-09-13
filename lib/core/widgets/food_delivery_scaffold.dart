import 'package:flutter/material.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/restaurants/presentation/screens/profile_screen.dart';
import 'app_bottom_navbar.dart';
import '../themes/app_colors.dart';

class FoodDeliveryScaffold extends StatefulWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final bool showBottomNav;
  final Color? backgroundColor;

  const FoodDeliveryScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.showBottomNav = true,
    this.backgroundColor,
  });

  static FoodDeliveryScaffoldState? of(BuildContext context) {
    return context.findAncestorStateOfType<FoodDeliveryScaffoldState>();
  }

  @override
  State<FoodDeliveryScaffold> createState() => FoodDeliveryScaffoldState();
}

class FoodDeliveryScaffoldState extends State<FoodDeliveryScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeDrawer = 'profile';

  void openProfileDrawer() {
    setState(() {
      _activeDrawer = 'profile';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState?.openEndDrawer();
    });
  }

  void openCartDrawer() {
    setState(() {
      _activeDrawer = 'cart';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState?.openEndDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: widget.appBar,
      backgroundColor: widget.backgroundColor ?? AppColors.font2,
      endDrawer: _activeDrawer == 'profile'
          ? const ProfileScreen(key: ValueKey('profile_drawer'))
          : const CartScreen(key: ValueKey('cart_drawer')),
      drawerScrimColor: const Color(0x4FFE4A0C),
      body: Stack(
        children: [
          widget.body,
          if (widget.showBottomNav)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavbar(
                onProfileTap: openProfileDrawer,
              ),
            ),
        ],
      ),
    );
  }
}
