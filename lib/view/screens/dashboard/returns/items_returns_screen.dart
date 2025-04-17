import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class ItemsReturnsScreen extends StatelessWidget {
  const ItemsReturnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScaffold(
      title: "Items Returns",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header with returns summary
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey900 : AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey400.withValues(alpha: 0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.arrowRotateLeft,
                      color: AppColors.primaryBlue,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Returns Overview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Main menu options
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MenuCard(
                    icon: FontAwesomeIcons.triangleExclamation,
                    title: 'Damages',
                    description: 'Track and manage damaged items returns',
                    color: AppColors.warning,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.calendarXmark,
                    title: 'Expired Items',
                    description: 'Manage expired product returns',
                    color: AppColors.error,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.ban,
                    title: 'Canceled Items',
                    description: 'Handle canceled order returns',
                    color: AppColors.secondary,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            // Bottom spacing
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
