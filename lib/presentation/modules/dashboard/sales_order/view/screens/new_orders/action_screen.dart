import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/action_screens/capture_images/image_capture_screen.dart';
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
  final LatLng currentDeviceLocation;
  final SalesOrderModel salesOrder;

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showCompletedDialog(String processName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Process Completed',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            content: Text(
              'The $processName process has already been completed for this order.',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                ),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showResetConfirmation(processName);
                },
                child: const Text(
                  'Reset & Redo',
                  style: TextStyle(color: AppColors.primaryBlue),
                ),
              ),
            ],
          ),
    );
  }

  void _showResetConfirmation(String processName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Reset Process',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            content: Text(
              'Are you sure you want to reset the $processName process? This will allow you to redo it.',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _resetProcess(processName);
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Reset',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _resetProcess(String processName) async {
    final salesOrderId = widget.salesOrder.id ?? '';

    switch (processName.toLowerCase()) {
      case 'unloading':
        await AppPreferences.clearProcessCompletion(
          'process_unloading_',
          salesOrderId,
        );
        break;
      case 'capture images':
        await AppPreferences.clearProcessCompletion(
          'process_capture_images_',
          salesOrderId,
        );
        break;
      case 'capture signature':
        await AppPreferences.clearProcessCompletion(
          'process_capture_signature_',
          salesOrderId,
        );
        break;
      case 'print invoice':
        await AppPreferences.clearProcessCompletion(
          'process_print_invoice_',
          salesOrderId,
        );
        break;
    }

    setState(() {});
  }

  Future<void> _handleUnloadingAction() async {
    final salesOrderId = widget.salesOrder.id ?? '';
    final isCompleted = await AppPreferences.isUnloadingCompleted(salesOrderId);

    if (isCompleted) {
      _showCompletedDialog('Unloading');
    } else {
      AppNavigator.push(
        context,
        PicklistDetailsScreen(
          salesOrder: widget.salesOrder,
          salesOrderLocation: widget.salesOrderLocation,
          currentDeviceLocation: widget.currentDeviceLocation,
        ),
      );
    }
  }

  Future<void> _handleCaptureImagesAction() async {
    final salesOrderId = widget.salesOrder.id ?? '';
    final isCompleted = await AppPreferences.isCaptureImagesCompleted(
      salesOrderId,
    );

    if (isCompleted) {
      _showCompletedDialog('Capture Images');
    } else {
      AppNavigator.push(
        context,
        ImageCaptureScreen(
          salesOrder: widget.salesOrder,
          salesOrderLocation: widget.salesOrderLocation,
          currentDeviceLocation: widget.currentDeviceLocation,
        ),
      );
    }
  }

  Future<void> _handleCaptureSignatureAction() async {
    final salesOrderId = widget.salesOrder.id ?? '';
    final isCompleted = await AppPreferences.isCaptureSignatureCompleted(
      salesOrderId,
    );

    if (isCompleted) {
      _showCompletedDialog('Capture Signature');
    } else {
      AppNavigator.push(
        context,
        SignatureScreen(
          salesOrder: widget.salesOrder,
          salesOrderLocation: widget.salesOrderLocation,
          currentDeviceLocation: widget.currentDeviceLocation,
        ),
      );
    }
  }

  Future<void> _handlePrintInvoiceAction() async {
    final salesOrderId = widget.salesOrder.id ?? '';
    final isCompleted = await AppPreferences.isPrintInvoiceCompleted(
      salesOrderId,
    );

    if (isCompleted) {
      _showCompletedDialog('Print Invoice');
    } else {
      AppNavigator.push(
        context,
        PrintDeliveryInvoiceScreen(
          salesOrder: widget.salesOrder,
          salesOrderLocation: widget.salesOrderLocation,
          currentDeviceLocation: widget.currentDeviceLocation,
        ),
      );
    }
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
      body: BlocProvider(
        create: (context) => SalesCubit(),
        child: SafeArea(
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
                FutureBuilder<bool>(
                  future: AppPreferences.isUnloadingCompleted(
                    widget.salesOrder.id ?? '',
                  ),
                  builder: (context, snapshot) {
                    final isCompleted = snapshot.data ?? false;
                    return _buildActionButton(
                      title: 'Start Unloading',
                      subtitle:
                          isCompleted
                              ? 'Process completed ✓'
                              : 'Begin the delivery process',
                      icon: Icons.local_shipping,
                      onPressed: _handleUnloadingAction,
                      color: isCompleted ? Colors.green : Colors.green,
                      isCompleted: isCompleted,
                    );
                  },
                ),
                const SizedBox(height: 16),
                FutureBuilder<bool>(
                  future: AppPreferences.isCaptureImagesCompleted(
                    widget.salesOrder.id ?? '',
                  ),
                  builder: (context, snapshot) {
                    final isCompleted = snapshot.data ?? false;
                    return _buildActionButton(
                      title: 'Capture Images',
                      subtitle:
                          isCompleted
                              ? 'Process completed ✓'
                              : 'Take photos of the delivery',
                      icon: Icons.camera_alt,
                      onPressed: _handleCaptureImagesAction,
                      color: isCompleted ? Colors.green : Colors.blue,
                      isCompleted: isCompleted,
                    );
                  },
                ),
                const SizedBox(height: 16),
                FutureBuilder<bool>(
                  future: AppPreferences.isCaptureSignatureCompleted(
                    widget.salesOrder.id ?? '',
                  ),
                  builder: (context, snapshot) {
                    final isCompleted = snapshot.data ?? false;
                    return _buildActionButton(
                      title: 'Capture Signature',
                      subtitle:
                          isCompleted
                              ? 'Process completed ✓'
                              : 'Get customer confirmation',
                      icon: Icons.draw,
                      onPressed: _handleCaptureSignatureAction,
                      color: isCompleted ? Colors.green : Colors.purple,
                      isCompleted: isCompleted,
                    );
                  },
                ),
                const SizedBox(height: 16),
                FutureBuilder<bool>(
                  future: AppPreferences.isPrintInvoiceCompleted(
                    widget.salesOrder.id ?? '',
                  ),
                  builder: (context, snapshot) {
                    final isCompleted = snapshot.data ?? false;
                    return _buildActionButton(
                      title: 'Print Delivery Invoice',
                      subtitle:
                          isCompleted
                              ? 'Process completed ✓'
                              : 'Generate delivery documentation',
                      icon: Icons.receipt_long,
                      onPressed: _handlePrintInvoiceAction,
                      color: isCompleted ? Colors.green : Colors.orange,
                      isCompleted: isCompleted,
                    );
                  },
                ),
              ],
            ),
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
    bool isCompleted = false,
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
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isCompleted ? Colors.green : color,
          width: isCompleted ? 2 : 1,
        ),
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
                    color: (isCompleted ? Colors.green : color).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_circle : icon,
                    color: isCompleted ? Colors.green : color,
                    size: 20,
                  ),
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
                        style: TextStyle(
                          fontSize: 12,
                          color: isCompleted ? Colors.green : textColor,
                          fontWeight:
                              isCompleted ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: (isCompleted ? Colors.green : color).withValues(
                    alpha: 0.5,
                  ),
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
