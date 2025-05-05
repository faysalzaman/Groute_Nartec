// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';

class PrintDeliveryInvoiceScreen extends StatefulWidget {
  const PrintDeliveryInvoiceScreen({
    super.key,
    required this.salesOrderLocation,
    required this.currentDeviceLocation,
    required this.salesOrder,
  });

  final LatLng salesOrderLocation;
  final LatLng currentDeviceLocation; // Add this parameter
  final SalesOrderModel salesOrder;

  @override
  State<PrintDeliveryInvoiceScreen> createState() =>
      _PrintDeliveryInvoiceScreenState();
}

class _PrintDeliveryInvoiceScreenState
    extends State<PrintDeliveryInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesCubit, SalesState>(
      listener: (context, state) {
        print(state);
        if (state is SalesStatusUpdateSuccessState) {
          Navigator.pop(context);
          Navigator.pop(context);
          AppSnackbars.success(context, "Sales Invoice updated successfully.");
        }
        if (state is SalesStatusUpdateErrorState) {
          AppSnackbars.danger(
            context,
            state.error.replaceAll("Exception: ", ""),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryBlue,
            title: const Text('Delivery Invoice'),
          ),
          body: Container(
            color: AppColors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CustomElevatedButton(
                          onPressed: () {
                            // TODO: Implement e-invoice generation
                          },
                          title: 'Generate E-Invoice',
                          height: 40,
                        ),
                        const SizedBox(height: 20),
                        CustomElevatedButton(
                          title: 'Print Delivery Invoice',
                          height: 40,
                          onPressed: () async {
                            final now = DateTime.now();
                            await context
                                .read<SalesCubit>()
                                .updateStatus(widget.salesOrder.id!, {
                                  'endJourneyTime': now.toIso8601String(),
                                  'status': 'Completed',
                                });
                          },
                          buttonState:
                              state is SalesStatusUpdateLoadingState
                                  ? ButtonState.loading
                                  : ButtonState.normal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
