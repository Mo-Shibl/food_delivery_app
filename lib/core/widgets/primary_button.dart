import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
 final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
   required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 207,
      height: 45,
      child: ElevatedButton(
       onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orangeBase,
          foregroundColor: AppColors.font2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: AppTextStyles.title.copyWith(
            color: AppColors.font2,
          ),
        ),
      ),
    );
  }
}