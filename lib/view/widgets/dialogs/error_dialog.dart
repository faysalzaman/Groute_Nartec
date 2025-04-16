import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback? onPressed;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.buttonText,
    this.onPressed,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String buttonText,
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      builder:
          (context) => ErrorDialog(
            title: title,
            buttonText: buttonText,
            onPressed: onPressed ?? () => Navigator.pop(context),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Icon(Icons.error_outline, color: AppColors.textDark, size: 50),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onPressed ?? () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textDark,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
