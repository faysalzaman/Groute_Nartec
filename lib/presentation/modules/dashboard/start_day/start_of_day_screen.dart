import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/new_orders_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/vehicle_check/vehicle_check_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/vehicle_check/vehicle_information_screen.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:groute_nartec/presentation/widgets/menu_card.dart';

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
                    onTap: () {
                      _showVehicleCheckConfirmationDialog(context);
                    },
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.truckRampBox,
                    title: 'Loading / Unloading',
                    description: 'Manage cargo operations',
                    color: AppColors.warning,
                    onTap: () {
                      AppNavigator.push(context, NewOrdersScreen());
                    },
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

  void _showVehicleCheckConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.carRear,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 10),
              const Text(
                'Vehicle Check',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Do you want to perform the daily vehicle inspection now?',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                AppNavigator.push(context, VehicleInformationScreen());
              },
              child: const Text(
                'No, Later',
                style: TextStyle(color: AppColors.textMedium),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                AppNavigator.push(context, VehicleCheckScreen());
              },
              child: const Text(
                'Yes, Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
