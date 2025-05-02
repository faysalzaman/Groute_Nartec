import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/view/widgets/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';
import 'package:groute_nartec/view/widgets/rectangle_card.dart'
    show RectangleCard;

class ParametersScreen extends StatelessWidget {
  const ParametersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Parameters",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header with parameters summary
            // This is a placeholder for the top header. You can replace it with your own widget.
            RectangleCard(
              title: "Parameters Overview",
              icon: FontAwesomeIcons.gears,
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
                    icon: FontAwesomeIcons.gear,
                    title: 'Settings',
                    description: 'Configure system settings and preferences',
                    color: AppColors.primaryBlue,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.wifi,
                    title: 'Connectivity',
                    description: 'Manage network and connection settings',
                    color: AppColors.info,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.userPlus,
                    title: 'Users Creation',
                    description: 'Manage user accounts and permissions',
                    color: AppColors.secondary,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.userShield,
                    title: 'Admin Panel',
                    description: 'Access administrative controls and settings',
                    color: AppColors.success,
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
