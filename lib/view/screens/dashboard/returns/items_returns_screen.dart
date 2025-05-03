import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/view/widgets/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';
import 'package:groute_nartec/view/widgets/rectangle_card.dart';

class ItemsReturnsScreen extends StatelessWidget {
  const ItemsReturnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Items Returns",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top header with returns summary
            RectangleCard(
              title: "Returns Overview",
              icon: FontAwesomeIcons.arrowRotateLeft,
              color: AppColors.primaryLight,
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
                    icon: FontAwesomeIcons.triangleExclamation,
                    title: 'Damages',
                    description: 'Track and manage damaged items returns',
                    color: AppColors.warning,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.calendarXmark,
                    title: 'Expired Items',
                    description: 'Manage expired product returns',
                    color: AppColors.error,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.ban,
                    title: 'Canceled Items',
                    description: 'Handle canceled order returns',
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
