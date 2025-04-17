import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class SalesInvoiceScreen extends StatelessWidget {
  const SalesInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Sales Invoice Management",
      automaticallyImplyLeading: true,
      body: Column(
        children: [
          // Top header with sales summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: .1),
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
                    color: AppColors.primaryBlue.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt_long,
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
                        'Sales Overview',
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
                  icon: Icons.payment,
                  title: 'Cash/Credit Sales',
                  description: 'Manage cash and credit transactions',
                  color: Colors.green,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.store,
                  title: 'Spot Sales',
                  description: 'Handle immediate sales transactions',
                  color: Colors.blue,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Outstanding Balance',
                  description: 'Track pending payments',
                  color: Colors.orange,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.discount,
                  title: 'Products Discounts',
                  description: 'Manage product discounts',
                  color: Colors.red,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.inventory_2,
                  title: 'Item Samples',
                  description: 'Track and manage product samples',
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
