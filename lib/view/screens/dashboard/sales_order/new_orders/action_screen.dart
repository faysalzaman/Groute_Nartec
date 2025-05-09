// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/new_orders/action_screens/delivery_invoice/print_invoice_delivery_screen.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/new_orders/action_screens/signature/signature_screen.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/new_orders/action_screens/unloading/unloading_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        automaticallyImplyLeading: false,
        // back button manually created
        leading: IconButton(
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
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'What would you like to do?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
                onPressed: () {},
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
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
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
