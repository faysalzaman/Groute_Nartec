import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_loading.dart';

enum ButtonState { idle, loading, disabled, success, error }

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    this.onPressed,
    required this.title,
    this.borderColor,
    this.textColor,
    this.buttonState = ButtonState.idle,
    this.height,
    this.width,
    this.fontSize,
    this.leadingIcon,
    this.trailingIcon,
  });

  final void Function()? onPressed;
  final String title;
  final Color? borderColor;
  final Color? textColor;
  final ButtonState? buttonState;
  final double? height;
  final double? width;
  final double? fontSize;
  final IconData? leadingIcon, trailingIcon;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: height ?? 45,
      width: width ?? double.infinity,
      child: OutlinedButton(
        onPressed: buttonState == ButtonState.disabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: _getBorderColor(isDarkMode), width: 1.5),
          foregroundColor: _getTextColor(isDarkMode),
          minimumSize: const Size(double.infinity, 48),
          maximumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: Container(
          height: 45,
          width: double.infinity,
          alignment: Alignment.center,
          child: _buildChild(isDarkMode),
        ),
      ),
    );
  }

  Color _getBorderColor(bool isDarkMode) {
    switch (buttonState) {
      case ButtonState.success:
        return AppColors.success;
      case ButtonState.error:
        return AppColors.error;
      case ButtonState.disabled:
        return Colors.grey;
      default:
        return borderColor ??
            (isDarkMode ? AppColors.primaryLight : AppColors.primaryBlue);
    }
  }

  Color _getTextColor(bool isDarkMode) {
    switch (buttonState) {
      case ButtonState.success:
        return AppColors.success;
      case ButtonState.error:
        return AppColors.error;
      case ButtonState.disabled:
        return Colors.grey;
      default:
        return textColor ??
            (isDarkMode ? AppColors.primaryLight : AppColors.primaryBlue);
    }
  }

  Widget _buildChild(bool isDarkMode) {
    final Color textColorValue = _getTextColor(isDarkMode);

    switch (buttonState) {
      case ButtonState.loading:
        return SizedBox(
          height: 24,
          width: 24,
          child: AppLoading(color: textColorValue),
        );
      case ButtonState.success:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: textColorValue, size: 24),
            const SizedBox(width: 8),
            Text(
              'Success',
              style: GoogleFonts.inter(
                fontSize: fontSize ?? 14,
                fontWeight: FontWeight.w600,
                color: textColorValue,
              ),
            ),
          ],
        );
      case ButtonState.error:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: textColorValue, size: 24),
            const SizedBox(width: 8),
            Text(
              'Error',
              style: GoogleFonts.inter(
                fontSize: fontSize ?? 14,
                fontWeight: FontWeight.w600,
                color: textColorValue,
              ),
            ),
          ],
        );
      default:
        if (leadingIcon != null || trailingIcon != null) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 20, color: textColorValue),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: fontSize ?? 14,
                  fontWeight: FontWeight.w600,
                  color: textColorValue,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, size: 20, color: textColorValue),
              ],
            ],
          );
        }
        return Text(
          title,
          style: GoogleFonts.inter(
            fontSize: fontSize ?? 14,
            fontWeight: FontWeight.w600,
            color: textColorValue,
          ),
          textAlign: TextAlign.center,
        );
    }
  }
}
