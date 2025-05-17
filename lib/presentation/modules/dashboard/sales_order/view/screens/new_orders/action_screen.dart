// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/action_screens/capture_images/display_products_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/action_screens/print_invoice_delivery_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/action_screens/signature_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/action_screens/unloading_screen.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';

class ActionScreen extends StatefulWidget {
  const ActionScreen({
    super.key,
    required this.salesOrderLocation,
    required this.currentDeviceLocation,
    required this.salesOrder,
  });

  final LatLng salesOrderLocation;
  final LatLng currentDeviceLocation; // Add this parameter
  final SalesOrderModel salesOrder;

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? AppColors.textLight : AppColors.textDark;
    return CustomScaffold(
      title: 'Delivery Actions',
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // a confirmation dialog
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text(
                      'Confirmation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    content: const Text(
                      'Are you sure you want go back and leave the delivery in progress?',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    actions: [
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
            );
          },
        ),
      ],
      padding: const EdgeInsets.symmetric(horizontal: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'What would you like to do?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                title: 'Start Unloading',
                subtitle: 'Begin the delivery process',
                icon: Icons.local_shipping,
                onPressed: () {
                  AppNavigator.push(
                    context,
                    PicklistDetailsScreen(
                      salesOrder: widget.salesOrder,
                      salesOrderLocation: widget.salesOrderLocation,
                      currentDeviceLocation: widget.currentDeviceLocation,
                    ),
                  );
                },
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                title: 'Capture Images',
                subtitle: 'Take photos of the delivery',
                icon: Icons.camera_alt,
                onPressed: () {
                  AppNavigator.push(
                    context,
                    DisplayProductScreen(
                      salesOrder: widget.salesOrder,
                      salesOrderLocation: widget.salesOrderLocation,
                      currentDeviceLocation: widget.currentDeviceLocation,
                    ),
                  );
                },
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                title: 'Capture Signature',
                subtitle: 'Get customer confirmation',
                icon: Icons.draw,
                onPressed: () {
                  AppNavigator.push(
                    context,
                    SignatureScreen(
                      salesOrder: widget.salesOrder,
                      salesOrderLocation: widget.salesOrderLocation,
                      currentDeviceLocation: widget.currentDeviceLocation,
                    ),
                  );
                },
                color: Colors.purple,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                title: 'Print Delivery Invoice',
                subtitle: 'Generate delivery documentation',
                icon: Icons.receipt_long,
                onPressed: () {
                  AppNavigator.push(
                    context,
                    PrintDeliveryInvoiceScreen(
                      salesOrder: widget.salesOrder,
                      salesOrderLocation: widget.salesOrderLocation,
                      currentDeviceLocation: widget.currentDeviceLocation,
                    ),
                  );
                },
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = isDarkTheme ? AppColors.textLight : AppColors.textDark;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color, width: 1),
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: textColor),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
