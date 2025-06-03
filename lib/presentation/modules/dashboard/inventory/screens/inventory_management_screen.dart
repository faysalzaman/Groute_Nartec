import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/screens/stocks_availability/stocks_availability_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/screens/stocks_on_van/stocks_on_van_screen.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:groute_nartec/presentation/widgets/menu_card.dart';

class InventoryManagementScreen extends StatelessWidget {
  const InventoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScaffold(
      title: "Inventory Management",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Warehouse Icon Banner
            Container(
              margin: const EdgeInsets.all(16),
              height: 160,
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
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.warehouse,
                            size: 64,
                            color: AppColors.primaryDark,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Warehouse',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.boxOpen,
                          size: 24,
                          color: AppColors.primaryDark.withValues(alpha: 0.6),
                        ),
                        FaIcon(
                          FontAwesomeIcons.truck,
                          size: 24,
                          color: AppColors.primaryDark.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Main menu options in a grid with fixed height
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
                    icon: FontAwesomeIcons.boxesStacked,
                    title: 'Sales Stock Availability',
                    description: 'Check current stock levels',
                    color: AppColors.warning,
                    onTap: () {
                      AppNavigator.push(context, StocksAvailabilityScreen());
                    },
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.truckRampBox,
                    title: 'Request Van Stock',
                    description: 'Request stock for your van',
                    color: AppColors.info,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.clipboardCheck,
                    title: 'Reconcile Van Stock',
                    description: 'Verify and update van inventory',
                    color: AppColors.primaryBlue,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.truckMoving,
                    title: 'Stocks on Van',
                    description: 'View current van inventory',
                    color: AppColors.secondary,
                    onTap: () {
                      AppNavigator.push(context, StocksOnVanScreen());
                    },
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.rightLeft,
                    title: 'Transfer Van Stock',
                    description: 'Transfer stock between vans',
                    color: AppColors.success,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            // Add some padding at the bottom for better scrolling
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
