import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/view/screens/dashboard/about/about_screen.dart';
import 'package:groute_nartec/view/screens/dashboard/inventory/inventory_management_screen.dart';
import 'package:groute_nartec/view/screens/dashboard/parameters/parameters_screen.dart';
import 'package:groute_nartec/view/screens/dashboard/promotions/dynamic_promotions_screen.dart';
import 'package:groute_nartec/view/screens/dashboard/returns/items_returns_screen.dart';
import 'package:groute_nartec/view/screens/dashboard/route_plane/route_plan_screen.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_invoice/sales_invoice_screen.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/sales_order_management_screen.dart';
import 'package:groute_nartec/view/screens/dashboard/start_day/start_of_day_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Menu items data structure
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Start of Day',
      'icon': Icons.wb_sunny_rounded,
      'subtitle': 'Vehicle Checks\nLoading/Unloading\nView Assigned Routes',
    },
    {
      'title': 'Sales Order\nManagement',
      'icon': Icons.shopping_cart_rounded,
      'subtitle': 'New Orders\nSales Return\nOrder History\nCustom Profile',
    },
    {
      'title': 'Inventory\nManagement',
      'icon': Icons.inventory_2_rounded,
      'subtitle':
          'SO Stocks Availability\nRequest Van Stock\nReceive Van Stock\nTransfer Van Stock',
    },
    {
      'title': 'Route Plan\nManagement',
      'icon': Icons.map_rounded,
      'subtitle': 'Plan Route\nRoute Check\nRoute Statistics',
    },
    {
      'title': 'Sales Invoice\nManagement',
      'icon': Icons.receipt_long_rounded,
      'subtitle': 'Cash/Credit Sales\nSport Sales\nOutstanding Balance',
    },
    {
      'title': 'Dynamic\nPromotions',
      'icon': Icons.local_offer_rounded,
      'subtitle': 'Sales Promotion\nOffers\nNew/Other products',
    },
    {
      'title': 'Item\nReturns',
      'icon': Icons.assignment_return_rounded,
      'subtitle': 'Damages\nExpired Items\nCancelled Items',
    },
    {
      'title': 'Parameters',
      'icon': Icons.settings_rounded,
      'subtitle': 'Settings\nConnectivity\nUsers Creation\nAdmin panel',
    },
    {
      'title': 'About',
      'icon': Icons.info_rounded,
      'subtitle': 'Application Version\nNew Updates\nNew Release',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "GRoute Pro (Van sales)",
      automaticallyImplyLeading: false,
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              onTap: () {
                // Add navigation logic here
                if (menuItems[index]['title'] == 'Route Plan\nManagement') {
                  AppNavigator.push(context, RoutePlanScreen());
                } else if (menuItems[index]['title'] ==
                    'Sales Invoice\nManagement') {
                  AppNavigator.push(context, SalesInvoiceScreen());
                } else if (menuItems[index]['title'] == 'Dynamic\nPromotions') {
                  AppNavigator.push(context, DynamicPromotionsScreen());
                } else if (menuItems[index]['title'] == 'Item\nReturns') {
                  AppNavigator.push(context, ItemsReturnsScreen());
                } else if (menuItems[index]['title'] == 'Parameters') {
                  AppNavigator.push(context, ParametersScreen());
                } else if (menuItems[index]['title'] == 'About') {
                  AppNavigator.push(context, AboutScreen());
                } else if (menuItems[index]['title'] == 'Start of Day') {
                  AppNavigator.push(context, StartOfDayScreen());
                } else if (menuItems[index]['title'] ==
                    'Sales Order\nManagement') {
                  AppNavigator.push(context, SalesOrderManagementScreen());
                } else if (menuItems[index]['title'] ==
                    'Inventory\nManagement') {
                  AppNavigator.push(context, InventoryManagementScreen());
                }
              },
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      menuItems[index]['icon'],
                      size: 40,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      menuItems[index]['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        menuItems[index]['subtitle'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
