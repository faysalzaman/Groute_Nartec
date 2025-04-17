import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class ParametersScreen extends StatelessWidget {
  const ParametersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Parameters",
      automaticallyImplyLeading: true,
      body: Column(
        children: [
          // Top header with parameters summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
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
                  child: Icon(
                    Icons.settings_applications,
                    color: AppColors.primaryBlue,
                    size: 32,
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
          const SizedBox(height: 24),
          // Main menu options
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
              padding: const EdgeInsets.all(16),
              children: [
                MenuCard(
                  icon: Icons.settings,
                  title: 'Settings',
                  description: 'Configure system settings and preferences',
                  color: Colors.blue,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.wifi_tethering,
                  title: 'Connectivity',
                  description: 'Manage network and connection settings',
                  color: Colors.cyan,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.group_add,
                  title: 'Users Creation',
                  description: 'Manage user accounts and permissions',
                  color: Colors.indigo,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.admin_panel_settings,
                  title: 'Admin Panel',
                  description: 'Access administrative controls and settings',
                  color: Colors.teal,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
