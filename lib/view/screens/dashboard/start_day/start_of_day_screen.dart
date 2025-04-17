import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class StartOfDayScreen extends StatelessWidget {
  const StartOfDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Start of the Day",
      automaticallyImplyLeading: true,
      body: Column(
        children: [
          // Top banner with sun animation
          Container(
            margin: const EdgeInsets.all(16),
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.wb_sunny, size: 48, color: Colors.yellow),
            ),
          ),
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
                  icon: Icons.car_repair,
                  title: 'Vehicle Checks',
                  description: 'Complete daily vehicle inspection',
                  color: Colors.green,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.local_shipping,
                  title: 'Loading / Unloading',
                  description: 'Manage cargo operations',
                  color: Colors.orange,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.map,
                  title: 'View Assigned Routes',
                  description: 'Check your delivery schedule',
                  color: Colors.blue,
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
