import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';

class StockSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const StockSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search by item code, name, or batch...',
          hintStyle: TextStyle(color: AppColors.textMedium, fontSize: 14),
          prefixIcon: Icon(
            FontAwesomeIcons.magnifyingGlass,
            color: AppColors.primaryBlue,
            size: 16,
          ),
          suffixIcon:
              controller.text.isNotEmpty
                  ? IconButton(
                    onPressed: () => controller.clear(),
                    icon: Icon(
                      Icons.clear,
                      color: AppColors.textMedium,
                      size: 20,
                    ),
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: AppColors.white,
        ),
      ),
    );
  }
}
