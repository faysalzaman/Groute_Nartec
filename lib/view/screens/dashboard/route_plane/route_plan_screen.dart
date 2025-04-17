import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class RoutePlanScreen extends StatelessWidget {
  const RoutePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScaffold(
      title: "Route Plan Management",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header with route summary
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
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
                      FontAwesomeIcons.route,
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
                          'Today\'s Route',
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
                    icon: FontAwesomeIcons.mapLocationDot,
                    title: 'Plan Route',
                    description: 'Create and modify route plans',
                    color: AppColors.primaryBlue,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.clipboardCheck,
                    title: 'Route Check',
                    description: 'Verify and optimize routes',
                    color: AppColors.success,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.chartSimple,
                    title: 'Route Statistics',
                    description: 'View performance metrics',
                    color: AppColors.warning,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.clockRotateLeft,
                    title: 'Route History',
                    description: 'Past routes and analytics',
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
