import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 322,
      height: errorText == null ? 45 : 70,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: AppTextStyles.paragraph.copyWith(
          color: AppColors.font,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.paragraph.copyWith(
            color: AppColors.font,
          ),
          filled: true,
          fillColor: AppColors.yellow2,

          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(
              color: AppColors.orangeBase,
              width: 1.5,
            ),
          ),

          errorText: errorText,
          errorStyle: AppTextStyles.paragraph.copyWith(
            color: AppColors.orangeBase,
            fontSize: 12,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(
              color: AppColors.orangeBase,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}