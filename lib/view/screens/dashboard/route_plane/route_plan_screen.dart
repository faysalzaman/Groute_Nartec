import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/view/widgets/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';
import 'package:groute_nartec/view/widgets/rectangle_card.dart';

class RoutePlanScreen extends StatelessWidget {
  const RoutePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Route Plan Management",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top header with route summary
            RectangleCard(
              title: "Today's Route",
              icon: FontAwesomeIcons.route,
              color: AppColors.primaryBlue,
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
