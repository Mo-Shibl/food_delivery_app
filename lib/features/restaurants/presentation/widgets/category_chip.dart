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

    if (key.contains('snack')) {
      return Icons.fastfood_outlined;
    }

    if (key.contains('meal') || key.contains('food')) {
      return Icons.restaurant_outlined;
    }

    if (key.contains('vegan') || key.contains('veg')) {
      return Icons.eco_outlined;
    }

    if (key.contains('dessert') || key.contains('sweet')) {
      return Icons.icecream_outlined;
    }

    if (key.contains('drink') || key.contains('beverage')) {
      return Icons.local_drink_outlined;
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
                color: isSelected
                    ? Colors.white
                    : const Color(0xFFEA5B33),
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
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
