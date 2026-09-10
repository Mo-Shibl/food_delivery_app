import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class Loader extends StatelessWidget {
  final double size;

  const Loader({
    super.key,
    this.size = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          color: AppColors.orangeBase,
        ),
      ),
    );
  }
}