import 'package:flutter/material.dart';
import 'primary_button.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.message,
   required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: AppColors.orangeBase,
            ),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                color: AppColors.font,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 24),

            PrimaryButton(
              text: 'Retry',
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}