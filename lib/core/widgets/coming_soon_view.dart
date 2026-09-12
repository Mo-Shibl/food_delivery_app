// lib/core/widgets/coming_soon_view.dart
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

/// Shared placeholder for screens this project hasn't built out yet
/// (Search, Orders, Profile). Swap each usage for the real screen as
/// you implement it against the PDF spec.
class ComingSoonView extends StatelessWidget {
  final String title;
  final IconData icon;

  const ComingSoonView({
    super.key,
    required this.title,
    this.icon = Icons.construction_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.font2,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.orangeBase),
            const SizedBox(height: 12),
            Text(
              '$title — coming soon',
              style: const TextStyle(
                fontFamily: 'League Spartan',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.font,
              ),
            ),
          ],
        ),
      ),
    );
  }
}