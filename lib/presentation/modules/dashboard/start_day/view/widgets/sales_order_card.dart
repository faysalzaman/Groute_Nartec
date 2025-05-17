// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_date_formatter.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/action_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/screens/loading/new_orders_detail_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/new_orders_map_screen.dart';

/// actions to process or view order details.
class SalesOrderCard extends StatefulWidget {
  final SalesOrderModel salesOrder;

  const SalesOrderCard({super.key, required this.salesOrder});

  @override
  State<SalesOrderCard> createState() => _SalesOrderCardState();
}

class _SalesOrderCardState extends State<SalesOrderCard> {
  bool _isProcessing = false; // State variable for loading indicator

  // Function to handle location fetching and navigation
  Future<void> _processOrder(BuildContext context) async {
    if (!mounted) return; // Check if widget is still mounted

    setState(() {
      _isProcessing = true;
    });

    try {
      // 1. Check Location Permissions & Services
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          AppSnackbars.danger(
            context,
            "Location services are disabled. Please enable them.",
          );
        }
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            AppSnackbars.danger(
              context,
              "Location permissions are denied. Please enable them.",
            );
          }
          setState(() {
            _isProcessing = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          AppSnackbars.danger(
            context,
            "Location permissions are permanently denied. Please enable them in settings.",
          );
        }
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      // 2. Get Current Location
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng currentDeviceLocation = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      // 3. Get Destination Location (Customer)
      final customerLat = double.tryParse(
        widget.salesOrder.customer?.latitude?.toString() ?? '',
      );
      final customerLng = double.tryParse(
        widget.salesOrder.customer?.longitude?.toString() ?? '',
      );

      if (customerLat == null || customerLng == null) {
        if (mounted) {
          AppSnackbars.danger(
            context,
            "Invalid customer location data. Please check the order details.",
          );
        }
        setState(() {
          _isProcessing = false;
        });
        return;
      }
      LatLng destinationLocation = LatLng(customerLat, customerLng);

      // 4. Navigate to Map Screen
      if (mounted) {
        if (widget.salesOrder.status?.toLowerCase() == 'completed') {
          AppNavigator.push(
            context,
            ActionScreen(
              salesOrder: widget.salesOrder,
              salesOrderLocation: destinationLocation,
              currentDeviceLocation: currentDeviceLocation,
            ),
          );
        } else {
          AppNavigator.push(
            context,
            NewOrdersMapScreen(
              salesOrder: widget.salesOrder,
              salesOrderLocation: destinationLocation,
              currentDeviceLocation: currentDeviceLocation,
            ),
          );
        }
      }
    } catch (e) {
      // Handle potential errors during location fetching
      if (mounted) {
        AppSnackbars.danger(context, "Failed to get location: $e");
      }
    } finally {
      // Ensure the loading indicator is turned off
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Format date
    String formattedDate = 'N/A';
    if (widget.salesOrder.orderDate != null) {
      try {
        final dateTime = DateTime.parse(widget.salesOrder.orderDate!);
        formattedDate = AppDateFormatter.formatDate(dateTime);
      } catch (e) {
        formattedDate = widget.salesOrder.orderDate ?? 'N/A';
      }
    }

    // Get item count
    final itemCount = widget.salesOrder.salesInvoiceDetails?.length ?? 0;

    // Get customer name and address
    final customerName =
        widget.salesOrder.customer?.companyNameEnglish ?? 'Unknown Customer';
    final deliveryAddress =
        widget.salesOrder.customer?.address ?? 'No address provided';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isDarkMode ? 1 : 2,
      shadowColor:
          isDarkMode
              ? AppColors.primaryDark.withValues(alpha: 0.4)
              : AppColors.primaryBlue.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isDarkMode
                ? BorderSide(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  width: 0.5,
                )
                : BorderSide.none,
      ),
      color:
          isDarkMode
              ? AppColors.darkBackground.withValues(alpha: 0.95)
              : AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.salesOrder.status),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  widget.salesOrder.status?.toUpperCase() ?? 'NEW',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  formattedDate,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 18,
                            color:
                                isDarkMode
                                    ? AppColors.primaryLight
                                    : AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Order #${widget.salesOrder.salesInvoiceNumber ?? 'N/A'}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    isDarkMode
                                        ? AppColors.textLight
                                        : AppColors.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Customer details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 18,
                      color:
                          isDarkMode
                              ? AppColors.primaryLight
                              : AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customerName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color:
                                  isDarkMode
                                      ? AppColors.textLight
                                      : AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            deliveryAddress,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  isDarkMode
                                      ? AppColors.grey400
                                      : AppColors.textMedium,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Order summary
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? AppColors.primaryDark.withValues(alpha: 0.3)
                            : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 16,
                            color:
                                isDarkMode
                                    ? AppColors.primaryLight
                                    : AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$itemCount item${itemCount != 1 ? 's' : ''}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  isDarkMode
                                      ? AppColors.grey300
                                      : AppColors.textMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Total: ${widget.salesOrder.totalAmount ?? 'N/A'}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDarkMode
                                  ? AppColors.secondary
                                  : AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed:
                      _isProcessing
                          ? null
                          : () {
                            AppNavigator.push(
                              context,
                              NewOrdersDetailScreen(
                                salesOrder: widget.salesOrder,
                              ),
                            );
                          },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color:
                          isDarkMode
                              ? AppColors.primaryLight
                              : AppColors.primaryBlue,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    Icons.info_outline,
                    size: 18,
                    color:
                        isDarkMode
                            ? AppColors.primaryLight
                            : AppColors.primaryBlue,
                  ),
                  label: Text(
                    'Start Picking',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? AppColors.primaryLight
                              : AppColors.primaryBlue,
                    ),
                  ),
                ),
                // const SizedBox(width: 12),
                // CustomElevatedButton(
                //   width: 120,
                //   height: 40,
                //   onPressed:
                //       _isProcessing ? null : () => _processOrder(context),
                //   backgroundColor: AppColors.primaryBlue,
                //   foregroundColor: AppColors.white,
                //   title: 'Process',
                //   buttonState:
                //       _isProcessing ? ButtonState.loading : ButtonState.normal,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return AppColors.primaryBlue;

    switch (status.toLowerCase()) {
      case 'new':
      case 'pending':
        return AppColors.primaryBlue;
      case 'processing':
      case 'in progress':
        return AppColors.orange;
      case 'completed':
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
      case 'failed':
        return AppColors.error;
      default:
        return AppColors.primaryBlue;
    }
  }
}
