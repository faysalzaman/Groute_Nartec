import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/view/widgets/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';
import 'package:groute_nartec/view/widgets/rectangle_card.dart'
    show RectangleCard;

class SalesInvoiceScreen extends StatelessWidget {
  const SalesInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Sales Invoice Management",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top header with sales summary
            RectangleCard(
              title: "Sales Overview",
              icon: FontAwesomeIcons.fileInvoiceDollar,
              color: AppColors.secondaryLight,
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
                    icon: FontAwesomeIcons.creditCard,
                    title: 'Cash/Credit Sales',
                    description: 'Manage cash and credit transactions',
                    color: AppColors.success,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.store,
                    title: 'Spot Sales',
                    description: 'Handle immediate sales transactions',
                    color: AppColors.primaryBlue,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.wallet,
                    title: 'Outstanding Balance',
                    description: 'Track pending payments',
                    color: AppColors.warning,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.tags,
                    title: 'Products Discounts',
                    description: 'Manage product discounts',
                    color: AppColors.error,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.boxOpen,
                    title: 'Item Samples',
                    description: 'Track and manage product samples',
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
