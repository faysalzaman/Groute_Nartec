import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/customer_profile/customer_profile_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/new_orders_screen.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:groute_nartec/presentation/widgets/menu_card.dart';
import 'package:groute_nartec/presentation/widgets/rectangle_card.dart';

class SalesOrderManagementScreen extends StatelessWidget {
  const SalesOrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Sales Order Management",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                childAspectRatio: 0.6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                children: [
                  MenuCard(
                    icon: FontAwesomeIcons.cartPlus,
                    title: 'New Orders',
                    description: 'Create and manage new sales orders',
                    color: AppColors.primaryBlue,
                    onTap: () {
                      AppNavigator.push(context, NewOrdersScreen());
                    },
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
                    onTap: () {
                      AppNavigator.push(context, CustomerProfileScreen());
                    },
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
