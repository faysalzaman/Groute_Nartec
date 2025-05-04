import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/view/widgets/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class StartOfDayScreen extends StatelessWidget {
  const StartOfDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Start of the Day",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner with sun animation
            Container(
              margin: const EdgeInsets.all(16),
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryLight, width: 2),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.sun,
                  size: 42,
                  color: Color(0xFFFFD700), // Gold color for sun
                ),
              ),
            ),
            // Main menu options
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MenuCard(
                    icon: FontAwesomeIcons.carRear,
                    title: 'Vehicle Checks',
                    description: 'Complete daily vehicle inspection',
                    color: AppColors.success,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.truckRampBox,
                    title: 'Loading / Unloading',
                    description: 'Manage cargo operations',
                    color: AppColors.warning,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.mapLocation,
                    title: 'View Assigned Routes',
                    description: 'Check your delivery schedule',
                    color: AppColors.primaryBlue,
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
