import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class DynamicPromotionsScreen extends StatelessWidget {
  const DynamicPromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Dynamic Promotions",
      automaticallyImplyLeading: true,
      body: Column(
        children: [
          // Top header with promotions summary
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
                    Icons.campaign,
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
                        'Active Promotions',
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
                  icon: Icons.campaign,
                  title: 'Sales Promotions',
                  description: 'Manage ongoing sales promotions and campaigns',
                  color: Colors.orange,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.card_giftcard,
                  title: 'Offers',
                  description: 'Special offers and discounts',
                  color: Colors.red,
                  onTap: () {},
                ),
                MenuCard(
                  icon: Icons.new_releases,
                  title: 'New Products',
                  description: 'Showcase and promote new products',
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
