import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_loading.dart';

enum ButtonState { normal, loading, disabled, success, error }

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.title,
    this.backgroundColor,
    this.foregroundColor,
    this.buttonState = ButtonState.normal,
    this.height,
    this.width,
    this.fontSize,
    this.leadingIcon,
    this.trailingIcon,
  });

  final void Function()? onPressed;
  final String title;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ButtonState? buttonState;
  final double? height;
  final double? width;
  final double? fontSize;
  final IconData? leadingIcon, trailingIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: buttonState == ButtonState.disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: foregroundColor ?? AppColors.textLight,
          minimumSize: const Size(double.infinity, 48),
          maximumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: Container(
          height: 45,
          width: double.infinity,
          alignment: Alignment.center,
          child: _buildChild(),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (buttonState) {
      case ButtonState.success:
        return AppColors.success;
      case ButtonState.error:
        return AppColors.error;
      case ButtonState.disabled:
        return Colors.grey;
      default:
        return backgroundColor ?? AppColors.primaryBlue;
    }
  }

  Widget _buildChild() {
    switch (buttonState) {
      case ButtonState.loading:
        return const SizedBox(height: 24, width: 24, child: AppLoading());
      case ButtonState.success:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: AppColors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              'Success',
              style: GoogleFonts.inter(
                fontSize: fontSize ?? 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        );
      case ButtonState.error:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: AppColors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              'Error',
              style: GoogleFonts.inter(
                fontSize: fontSize ?? 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
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
                Icon(leadingIcon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: fontSize ?? 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, size: 20),
              ],
            ],
          );
        }
        return Text(
          title,
          style: GoogleFonts.inter(
            fontSize: fontSize ?? 14,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        );
    }
  }
}
