// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/cubit/sales_cubit.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/cubit/sales_state.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/view/widgets/buttons/custom_elevated_button.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesCubit, SalesState>(
      listener: (context, state) {
        if (state is SalesStatusUpdateSuccessState) {
          Navigator.pop(context);
          Navigator.pop(context);
          AppSnackbars.success(context, 'Unloading completed successfully');
        } else if (state is SalesStatusUpdateErrorState) {
          AppSnackbars.danger(context, state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: const Text('Picklist Details'),
            elevation: 2,
            backgroundColor: AppColors.primaryBlue,
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                await context.read<SalesCubit>().updateStatus(
                  widget.salesOrder.id!,
                  {"unloadingTime": now.toIso8601String()},
                );
              },
              title: 'Unloading Complete',
              buttonState:
                  state is SalesStatusUpdateLoadingState
                      ? ButtonState.loading
                      : ButtonState.normal,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.white,
                elevation: 5,
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            widget.salesOrder.salesInvoiceDetails!.length,
                        itemBuilder: (context, index) {
                          final item =
                              widget.salesOrder.salesInvoiceDetails![index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                            color: AppColors.white,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(
                                item.id ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                    'Product Name',
                                    item.productName ?? 'N/A',
                                  ),
                                  _buildInfoRow(
                                    'Product Price',
                                    item.price ?? 'N/A',
                                  ),
                                  _buildInfoRow(
                                    'Product Quantity',
                                    item.quantity ?? 'N/A',
                                  ),
                                  _buildInfoRow(
                                    'Procuct Description',
                                    item.productDescription ?? 'N/A',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
