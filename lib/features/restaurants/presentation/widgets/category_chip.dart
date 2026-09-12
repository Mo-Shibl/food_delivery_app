// lib/features/restaurants/presentation/widgets/category_chip.dart
import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    final key = label.toLowerCase();

    if (key == 'all') return Icons.grid_view_rounded;
    if (key.contains('biryani')) return Icons.rice_bowl_outlined;
    if (key.contains('seafood')) return Icons.set_meal_outlined;
    if (key.contains('dessert') || key.contains('sweet')) {
      return Icons.icecream_outlined;
    }
    if (key.contains('drink') || key.contains('brewery')) {
      return Icons.local_drink_outlined;
    }
    if (key.contains('vegan') || key.contains('veg')) {
      return Icons.eco_outlined;
    }

    return Icons.restaurant_menu_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFEA5B33)
                    : const Color(0xFFF6E5A8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icon,
                color: isSelected ? Colors.white : const Color(0xFFEA5B33),
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2B2B2B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}