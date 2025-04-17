// lib/view/screens/route_plan/route_plan_screen.dart
import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class RoutePlanScreen extends StatelessWidget {
  const RoutePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Route Plan Management",
      automaticallyImplyLeading: true,
      body: Column(
        children: [
          // Top header with route summary
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
                    Icons.route,
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
          const SizedBox(height: 24),
          // Main menu options
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
              children: [
                MenuCard(
                  icon: Icons.map,
                  title: 'Plan Route',
                  description: 'Create and modify route plans',
                  color: Colors.blue,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.checklist_rtl,
                  title: 'Route Check',
                  description: 'Verify and optimize routes',
                  color: Colors.green,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.analytics,
                  title: 'Route Statistics',
                  description: 'View performance metrics',
                  color: Colors.orange,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.history,
                  title: 'Route History',
                  description: 'Past routes and analytics',
                  color: Colors.purple,
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
