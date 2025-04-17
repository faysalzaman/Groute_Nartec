import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class SalesOrderManagementScreen extends StatelessWidget {
  const SalesOrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Sales Order Management",
      automaticallyImplyLeading: true,
      body: Column(
        children: [
          // Top header with sales order icon
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
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.assignment,
                        color: Colors.blue,
                        size: 32,
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
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
                  icon: Icons.add_shopping_cart,
                  title: 'New Orders',
                  description: 'Create and manage new sales orders',
                  color: Colors.blue,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.assignment_return,
                  title: 'Sales Return',
                  description: 'Process sales returns and refunds',
                  color: Colors.green,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.history,
                  title: 'Order History',
                  description: 'View past orders and transactions',
                  color: Colors.orange,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.person,
                  title: 'Customer Profile',
                  description: 'Manage customer information',
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
