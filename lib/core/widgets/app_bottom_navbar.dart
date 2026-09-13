import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../themes/app_colors.dart';
import '../routing/app_routes.dart';

class AppBottomNavbar extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const AppBottomNavbar({
    super.key,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.orangeBase,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavItem(
            context,
            'assets/icons/Home.svg',
            onTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            ),
          ),
          _buildNavItem(
            context,
            'assets/icons/Search.svg',
            onTap: () => Navigator.pushNamed(context, AppRoutes.search),
          ),
          _buildNavItem(
            context,
            'assets/icons/Orders.svg',
            onTap: () => Navigator.pushNamed(context, AppRoutes.orders),
          ),
          _buildNavItem(
            context,
            'assets/icons/profile.svg',
            onTap: onProfileTap ?? () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String iconPath, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        iconPath,
        width: 28,
        height: 28,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
