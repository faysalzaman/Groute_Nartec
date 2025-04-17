import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class SalesOrderManagementScreen extends StatelessWidget {
  const SalesOrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScaffold(
      title: "Sales Order Management",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header with sales order icon
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey900 : AppColors.white,
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
                    child: Stack(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.fileInvoice,
                          color: AppColors.primaryBlue,
                          size: 28,
                        ),
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.warning,
                              shape: BoxShape.circle,
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.check,
                              color: AppColors.white,
                              size: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Orders Overview',
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
