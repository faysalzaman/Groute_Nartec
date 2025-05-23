import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';

/// A shimmer loading effect widget for the sales order card
class OrderCardShimmer extends StatelessWidget {
  const OrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      elevation: isDarkMode ? 1 : 2,
      shadowColor:
          isDarkMode
              ? AppColors.primaryDark.withValues(alpha: 0.4)
              : AppColors.primaryBlue.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isDarkMode
                ? BorderSide(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  width: 0.5,
                )
                : BorderSide.none,
      ),
      color:
          isDarkMode
              ? AppColors.darkBackground.withValues(alpha: 0.95)
              : AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status banner
          Container(
            width: double.infinity,
            height: 36,
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? AppColors.primaryDark.withValues(alpha: 0.3)
                      : AppColors.grey200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),

          // Order info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerItem(150, 16, isDarkMode),
                    _buildShimmerItem(80, 14, isDarkMode),
                  ],
                ),
                const SizedBox(height: 16),

                // Customer info
                _buildShimmerItem(200, 18, isDarkMode),
                const SizedBox(height: 8),
                _buildShimmerItem(240, 14, isDarkMode),
                const SizedBox(height: 16),

                // Date rows
                _buildDateRow(isDarkMode),
                const SizedBox(height: 8),
                _buildDateRow(isDarkMode),
                const SizedBox(height: 8),
                _buildDateRow(isDarkMode),
                const SizedBox(height: 16),

                // Order summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerItem(120, 16, isDarkMode),
                    _buildShimmerItem(100, 16, isDarkMode),
                  ],
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShimmerItem(100, 32, isDarkMode, radius: 8),
                _buildShimmerItem(120, 36, isDarkMode, radius: 8),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDateRow(bool isDarkMode) {
    return Row(
      children: [
        _buildShimmerItem(24, 24, isDarkMode, radius: 12),
        const SizedBox(width: 8),
        _buildShimmerItem(160, 14, isDarkMode),
      ],
    );
  }

  Widget _buildShimmerItem(
    double width,
    double height,
    bool isDarkMode, {
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.primaryDark.withValues(alpha: 0.3)
                : AppColors.grey200,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
