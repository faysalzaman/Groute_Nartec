import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class ParametersScreen extends StatelessWidget {
  const ParametersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScaffold(
      title: "Parameters",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header with parameters summary
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
                      FontAwesomeIcons.gears,
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
                          'System Parameters',
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
