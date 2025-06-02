// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/utils/app_date_formatter.dart';
import 'package:groute_nartec/core/utils/app_loading.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/action_screens/action_screen.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';

class PicklistDetailsScreen extends StatefulWidget {
  const PicklistDetailsScreen({
    super.key,
    required this.salesOrderLocation,
    required this.currentDeviceLocation,
    required this.salesOrder,
  });

  final LatLng salesOrderLocation;
  final LatLng currentDeviceLocation; // Add this parameter
  final SalesOrderModel salesOrder;

  @override
  State<PicklistDetailsScreen> createState() => _PicklistDetailsScreenState();
}

class _PicklistDetailsScreenState extends State<PicklistDetailsScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      context.read<SalesCubit>().getSalesInvoiceDetailsbySalesOrderId(
        widget.salesOrder.id.toString(),
      );
    });
  }

  getSalesInvoiceDetails() {
    context.read<SalesCubit>().getSalesInvoiceDetailsbySalesOrderId(
      widget.salesOrder.id.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesCubit, SalesState>(
      listener: (context, state) async {
        if (state is SalesStatusUpdateSuccessState) {
          // Mark the unloading process as completed
          await AppPreferences.setUnloadingCompleted(
            widget.salesOrder.id ?? '',
          );
          Navigator.pop(context);
          Navigator.pop(context);
          AppSnackbars.success(context, 'Unloading completed successfully');
        } else if (state is SalesStatusUpdateErrorState) {
          AppSnackbars.danger(context, state.error);
        } else if (state is UnloadItemsError) {
          AppSnackbars.danger(context, state.message);
        } else if (state is UnloadItemsLoaded) {
          // Mark the unloading process as completed
          await AppPreferences.setUnloadingCompleted(
            widget.salesOrder.id ?? '',
          );
          AppSnackbars.success(context, 'Unloading done successfully');

          context.read<SalesCubit>().getSalesInvoiceDetailsbySalesOrderId(
            widget.salesOrder.id.toString(),
          );
          Navigator.pop(context);

          AppNavigator.pushReplacement(
            context,
            ActionScreen(
              salesOrderLocation: widget.salesOrderLocation,
              currentDeviceLocation: widget.currentDeviceLocation,
              salesOrder: widget.salesOrder,
            ),
          );
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          title: "Unload Items",
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomElevatedButton(
                onPressed: () {
                  final salesInvoiceDetailsList =
                      context.read<SalesCubit>().salesInvoiceDetailsList;

                  final productIds =
                      salesInvoiceDetailsList
                          .map((item) => item.productId.toString())
                          .toList();
                  final ids =
                      salesInvoiceDetailsList
                          .map((item) => item.id.toString())
                          .toList();
                  final double totalPrice = salesInvoiceDetailsList
                      .map((item) {
                        final price = double.tryParse(item.price ?? '0') ?? 0.0;
                        final quantity =
                            double.tryParse(item.quantityPicked ?? '0') ?? 0.0;
                        return price * quantity;
                      })
                      .fold<double>(
                        0,
                        (previousValue, itemTotal) => previousValue + itemTotal,
                      );
                  final totalQuantity = salesInvoiceDetailsList.fold<int>(
                    0,
                    (previousValue, item) =>
                        previousValue +
                        (int.parse(item.quantityPicked.toString())),
                  );
                  context.read<SalesCubit>().newUnloadItems(
                    productIds,
                    ids,
                    totalPrice * totalQuantity,
                    totalQuantity,
                    widget.salesOrder.id.toString(),
                  );
                },
                title: 'Unloading Done',
                backgroundColor: AppColors.green,
                buttonState:
                    state is UnloadItemsLoading
                        ? ButtonState.loading
                        : ButtonState.idle,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Order Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.local_shipping,
                          size: 40,
                          color: AppColors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    state is SalesInvoiceDetailsLoading
                        ? AppLoading(color: AppColors.primaryBlue, size: 30)
                        : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              context
                                  .read<SalesCubit>()
                                  .salesInvoiceDetailsList
                                  .length,
                          itemBuilder: (context, index) {
                            final item =
                                context
                                    .read<SalesCubit>()
                                    .salesInvoiceDetailsList[index];
                            return _buildSalesInvoiceDetailCard(item);
                          },
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSalesInvoiceDetailCard(SalesInvoiceDetails item) {
    return Visibility(
      // visible: item.quantityPicked != "0",
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with product icon and ID
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.inventory_2,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.productDescription ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Product details in a grid
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoRow(
                            icon: Icons.label_important_outline_rounded,
                            label: 'Price',
                            value:
                                '${(int.parse(item.price ?? '0') * int.parse(item.quantityPicked ?? '0'))}',
                            valueColor: AppColors.green,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoRow(
                            icon: Icons.numbers,
                            label: 'Quantity',
                            value: '${item.quantityPicked ?? '0'} pcs',
                            valueColor: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Additional details row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.qr_code,
                            size: 16,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Barcode',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            item.productId ?? 'N/A',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          // dates
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Order Date',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            AppDateFormatter.fromString(
                              item.createdAt ?? '',
                              showTime: true,
                            ),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange[800],
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isTitle = false,
    Color? valueColor,
    int? maxLines,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isTitle ? 14 : 12,
                  fontWeight: isTitle ? FontWeight.bold : FontWeight.w600,
                  color: valueColor ?? Colors.grey[800],
                ),
                maxLines: maxLines,
                overflow: maxLines != null ? TextOverflow.ellipsis : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
