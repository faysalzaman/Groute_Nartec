import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';

class EmptyStockState extends StatelessWidget {
  const EmptyStockState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty State Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.boxOpen,
                size: 60,
                color: AppColors.primaryBlue,
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              'No Stocks Available',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              'There are currently no stocks loaded on this van.\nPlease load inventory items or check back later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textMedium,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to load inventory screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Load Inventory feature coming soon!'),
                        ),
                      );
                    },
                    icon: const Icon(FontAwesomeIcons.plus, size: 16),
                    label: const Text('Load Inventory'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to inventory management
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Inventory Management feature coming soon!',
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.gear,
                      size: 16,
                      color: AppColors.primaryBlue,
                    ),
                    label: Text(
                      'Manage Inventory',
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryBlue),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Help Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.circleInfo,
                  size: 14,
                  color: AppColors.textMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  'Need help? Contact support',
                  style: TextStyle(fontSize: 12, color: AppColors.textMedium),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
