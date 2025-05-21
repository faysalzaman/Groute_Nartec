import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_date_formatter.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/screens/loading/new_orders_detail_screen.dart';

/// actions to process or view order details.
class SalesOrderCard extends StatefulWidget {
  final SalesOrderModel salesOrder;

  const SalesOrderCard({super.key, required this.salesOrder});

  @override
  State<SalesOrderCard> createState() => _SalesOrderCardState();
}

class _SalesOrderCardState extends State<SalesOrderCard> {
  bool _isProcessing = false; // State variable for loading indicator
  bool _isBlinking = false; // State variable for blinking animation

  @override
  void initState() {
    super.initState();
    // Start blinking animation if it's today's order
    if (_isCurrentDateOrder()) {
      // Set up blinking animation timer
      _setupBlinkingAnimation();
    }
  }

  @override
  void dispose() {
    // Clean up any resources
    super.dispose();
  }

  // Function to check if the order date is the current date
  bool _isCurrentDateOrder() {
    if (widget.salesOrder.assignedTime == null) return false;

    try {
      final assignedTime = DateTime.parse(widget.salesOrder.assignedTime!);
      final now = DateTime.now();

      return assignedTime.year == now.year &&
          assignedTime.month == now.month &&
          assignedTime.day == now.day;
    } catch (e) {
      return false;
    }
  }

  // Set up blinking animation
  void _setupBlinkingAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isBlinking = !_isBlinking;
        });
        _setupBlinkingAnimation(); // Recursive call to create blinking effect
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isCurrentDate = _isCurrentDateOrder();

    // Format date
    String formattedDate = '';
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
              : isCurrentDate
              ? AppColors.orange.withValues(alpha: 0.4)
              : AppColors.primaryBlue.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isDarkMode
                ? BorderSide(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  width: 0.5,
                )
                : isCurrentDate
                ? BorderSide(
                  color: AppColors.orange.withValues(alpha: 0.3),
                  width: 1.0,
                )
                : BorderSide.none,
      ),
      color:
          isDarkMode
              ? AppColors.darkBackground.withValues(alpha: 0.95)
              : AppColors.white,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color:
                      isCurrentDate
                          ? AppColors.orange
                          : _getStatusColor(widget.salesOrder.status),
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
                              FaIcon(
                                FontAwesomeIcons.cartShopping,
                                size: 18,
                                color:
                                    isDarkMode
                                        ? AppColors.primaryLight
                                        : AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Order # ${widget.salesOrder.salesInvoiceNumber ?? 'N/A'}',
                                  style: theme.textTheme.titleSmall?.copyWith(
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.truck,
                                size: 18,
                                color:
                                    isDarkMode
                                        ? AppColors.primaryLight
                                        : AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'PO # ${widget.salesOrder.purchaseOrderNumber ?? 'N/A'}',
                                  style: theme.textTheme.titleSmall?.copyWith(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.hashtag,
                                size: 18,
                                color:
                                    isDarkMode
                                        ? AppColors.primaryLight
                                        : AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Ref # ${widget.salesOrder.serialNo ?? 'N/A'}',
                                  style: theme.textTheme.titleSmall?.copyWith(
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

          // New badge for current date orders
          if (isCurrentDate)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _isBlinking ? Colors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red, width: 1.5),
                ),
                child: Text(
                  'NEW',
                  style: TextStyle(
                    color: _isBlinking ? Colors.white : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
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
