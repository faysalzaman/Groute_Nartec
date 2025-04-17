import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';
import 'package:groute_nartec/view/widgets/rectangle_card.dart';

class SalesOrderManagementScreen extends StatelessWidget {
  const SalesOrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Sales Order Management",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header with sales order icon
            RectangleCard(
              title: "Orders Overview",
              icon: FontAwesomeIcons.check,
              color: AppColors.warning,
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
                    icon: FontAwesomeIcons.cartPlus,
                    title: 'New Orders',
                    description: 'Create and manage new sales orders',
                    color: AppColors.primaryBlue,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.arrowRotateLeft,
                    title: 'Sales Return',
                    description: 'Process sales returns and refunds',
                    color: AppColors.success,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.clockRotateLeft,
                    title: 'Order History',
                    description: 'View past orders and transactions',
                    color: AppColors.warning,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.userPen,
                    title: 'Customer Profile',
                    description: 'Manage customer information',
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
