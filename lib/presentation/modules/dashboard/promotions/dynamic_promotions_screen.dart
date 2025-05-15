import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:groute_nartec/presentation/widgets/menu_card.dart';
import 'package:groute_nartec/presentation/widgets/rectangle_card.dart'
    show RectangleCard;

class DynamicPromotionsScreen extends StatelessWidget {
  const DynamicPromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Dynamic Promotions",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top header with promotions summary
            RectangleCard(
              title: "Active Promotions",
              icon: FontAwesomeIcons.bullhorn,
              color: AppColors.primaryBlue,
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
                    icon: FontAwesomeIcons.bullhorn,
                    title: 'Sales Promotions',
                    description:
                        'Manage ongoing sales promotions and campaigns',
                    color: AppColors.warning,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.gift,
                    title: 'Offers',
                    description: 'Special offers and discounts',
                    color: AppColors.error,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.star,
                    title: 'New Products',
                    description: 'Showcase and promote new products',
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
