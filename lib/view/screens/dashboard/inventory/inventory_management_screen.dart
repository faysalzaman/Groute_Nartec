import 'package:flutter/material.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InventoryManagementScreen extends StatelessWidget {
  const InventoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Inventory Management",
      automaticallyImplyLeading: true,
      body: Column(
        children: [
          // Warehouse Icon Banner
          Container(
            margin: const EdgeInsets.all(16),
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E4B8E).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.warehouse,
                          size: 64,
                          color: const Color(0xFF1E4B8E),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E4B8E),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Warehouse',
                            style: TextStyle(
                              color: Colors.white,
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
                        color: const Color(0xFF1E4B8E).withValues(alpha: 0.6),
                      ),
                      FaIcon(
                        FontAwesomeIcons.truck,
                        size: 24,
                        color: const Color(0xFF1E4B8E).withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                  icon: FontAwesomeIcons.boxesStacked,
                  title: 'Sales Stock Availability',
                  description: 'Check current stock levels',
                  color: Colors.orange,
                  onTap: () {},
                ),
                MenuCard(
                  icon: FontAwesomeIcons.truckRampBox,
                  title: 'Request Van Stock',
                  description: 'Request stock for your van',
                  color: Colors.cyan,
                  onTap: () {},
                ),
                MenuCard(
                  icon: FontAwesomeIcons.clipboardCheck,
                  title: 'Reconcile Van Stock',
                  description: 'Verify and update van inventory',
                  color: Colors.blue,
                  onTap: () {},
                ),
                MenuCard(
                  icon: FontAwesomeIcons.truckMoving,
                  title: 'Stocks on Van',
                  description: 'View current van inventory',
                  color: Colors.amber,
                  onTap: () {},
                ),
                MenuCard(
                  icon: FontAwesomeIcons.rightLeft,
                  title: 'Transfer Van Stock',
                  description: 'Transfer stock between vans',
                  color: Colors.green,
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
