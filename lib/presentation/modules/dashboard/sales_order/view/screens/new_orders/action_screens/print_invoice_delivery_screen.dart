// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/action_screens/action_screen.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';

class PrintDeliveryInvoiceScreen extends StatefulWidget {
  const PrintDeliveryInvoiceScreen({
    super.key,
    required this.salesOrderLocation,
    required this.currentDeviceLocation,
    required this.salesOrder,
  });

  final LatLng salesOrderLocation;
  final LatLng currentDeviceLocation;
  final SalesOrderModel salesOrder;

  @override
  State<PrintDeliveryInvoiceScreen> createState() =>
      _PrintDeliveryInvoiceScreenState();
}

class _PrintDeliveryInvoiceScreenState
    extends State<PrintDeliveryInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? AppColors.textLight : AppColors.textDark;

    return BlocConsumer<SalesCubit, SalesState>(
      listener: (context, state) async {
        if (state is SalesOrderUploadInvoiceSuccessState) {
          // Show success message

          // Mark the process as completed
          await AppPreferences.setPrintInvoiceCompleted(
            widget.salesOrder.id ?? '',
          );

          Navigator.pop(context);
          // SalesCubit.get(context).rebuildActionScreen();
          AppNavigator.pushReplacement(
            context,
            ActionScreen(
              salesOrderLocation: widget.salesOrderLocation,
              currentDeviceLocation: widget.currentDeviceLocation,
              salesOrder: widget.salesOrder,
            ),
          );
          AppSnackbars.success(context, "Invoice generated successfully");
        }
        if (state is SalesOrderUploadInvoiceErrorState) {
          AppSnackbars.danger(
            context,
            state.error.replaceAll("Exception: ", ""),
          );
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          title: "Delivery E-Invoice",
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color:
                          isDarkTheme
                              ? AppColors.darkBackground.withValues(alpha: 0.95)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border:
                          isDarkTheme
                              ? Border.all(color: Colors.grey[700]!, width: 0.5)
                              : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 60,
                          color:
                              isDarkTheme
                                  ? AppColors.primaryLight.withValues(
                                    alpha: 0.9,
                                  )
                                  : AppColors.primaryBlue,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Generate Electronic Invoice',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Click the button below to generate an electronic invoice for this delivery.',
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        CustomElevatedButton(
                          onPressed:
                              state is SalesOrderUploadInvoiceLoadingState
                                  ? null
                                  : () async {
                                    // Upload invoice using the API
                                    await context
                                        .read<SalesCubit>()
                                        .uploadInvoice(widget.salesOrder.id!);
                                  },
                          title: 'Generate E-Invoice',
                          height: 50,
                          buttonState:
                              state is SalesOrderUploadInvoiceLoadingState
                                  ? ButtonState.loading
                                  : ButtonState.idle,
                          width: double.infinity,
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
