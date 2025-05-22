import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_date_formatter.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/screens/loading/new_orders_detail_screen.dart';

/// A card widget displaying sales order information with
/// actions to process or view order details.
class SalesOrderCard extends StatefulWidget {
  final SalesOrderModel salesOrder;

  const SalesOrderCard({super.key, required this.salesOrder});

  @override
  State<SalesOrderCard> createState() => _SalesOrderCardState();
}

class _SalesOrderCardState extends State<SalesOrderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    // Set up proper animation controller for blinking effect
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _blinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    // Start blinking animation if it's today's order
    if (_isCurrentDateOrder()) {
      _blinkController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
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
    } catch (_) {
      return false;
    }
  }

  // Helper method to handle card styling based on theme and order status
  CardStyle _getCardStyle(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isCurrentDate = _isCurrentDateOrder();

    return CardStyle(
      shadowColor:
          isDarkMode
              ? AppColors.primaryDark.withValues(alpha: 0.4)
              : isCurrentDate
              ? AppColors.orange.withValues(alpha: 0.4)
              : AppColors.primaryBlue.withValues(alpha: 0.2),
      borderSide:
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
      backgroundColor:
          isDarkMode
              ? AppColors.darkBackground.withValues(alpha: 0.95)
              : AppColors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isCurrentDate = _isCurrentDateOrder();
    final cardStyle = _getCardStyle(context);

    // Get order information
    final itemCount = widget.salesOrder.salesInvoiceDetails?.length ?? 0;
    final customerName =
        widget.salesOrder.customer?.companyNameEnglish ?? 'Unknown Customer';
    final deliveryAddress =
        widget.salesOrder.customer?.address ?? 'No address provided';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isDarkMode ? 1 : 2,
      shadowColor: cardStyle.shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: cardStyle.borderSide,
      ),
      color: cardStyle.backgroundColor,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status banner
              _buildStatusBanner(context, isCurrentDate),

              // Order details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderInfoRow(
                      context,
                      icon: FontAwesomeIcons.cartShopping,
                      text:
                          'Order # ${widget.salesOrder.salesInvoiceNumber ?? 'N/A'}',
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    _buildOrderInfoRow(
                      context,
                      icon: FontAwesomeIcons.truck,
                      text:
                          'PO # ${widget.salesOrder.purchaseOrderNumber ?? 'N/A'}',
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    _buildOrderInfoRow(
                      context,
                      icon: FontAwesomeIcons.hashtag,
                      text: 'Ref # ${widget.salesOrder.serialNo ?? 'N/A'}',
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    // Customer details
                    _buildCustomerInfo(
                      context,
                      customerName,
                      deliveryAddress,
                      isDarkMode,
                    ),

                    const SizedBox(height: 16),

                    // Order summary
                    _buildOrderSummary(context, itemCount, isDarkMode),
                  ],
                ),
              ),

              // Action buttons
              _buildFooterSection(context, isDarkMode),
            ],
          ),

          // New badge for current date orders
          if (isCurrentDate) _buildNewBadge(),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context, bool isCurrentDate) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
          // const Spacer(),
          // Text(
          //   formattedDate,
          //   style: theme.textTheme.bodySmall?.copyWith(
          //     color: AppColors.white.withValues(alpha: 0.9),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    required bool isDarkMode,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        FaIcon(
          icon,
          size: 18,
          color: isDarkMode ? AppColors.primaryLight : AppColors.primaryBlue,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.textLight : AppColors.textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo(
    BuildContext context,
    String customerName,
    String address,
    bool isDarkMode,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FaIcon(
          FontAwesomeIcons.user,
          size: 18,
          color: isDarkMode ? AppColors.primaryLight : AppColors.primaryBlue,
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
                  color: isDarkMode ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? AppColors.grey400 : AppColors.textMedium,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    int itemCount,
    bool isDarkMode,
  ) {
    final theme = Theme.of(context);

    return Container(
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
              FaIcon(
                FontAwesomeIcons.box,
                size: 18,
                color:
                    isDarkMode ? AppColors.primaryLight : AppColors.primaryBlue,
              ),
              const SizedBox(width: 6),
              Text(
                '$itemCount item${itemCount != 1 ? 's' : ''}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? AppColors.grey300 : AppColors.textMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            'Total: ${widget.salesOrder.totalAmount ?? 'N/A'}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context, bool isDarkMode) {
    final formattedDate = AppDateFormatter.fromString(
      widget.salesOrder.assignedTime ?? '',
      showTime: true,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Assign date
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? AppColors.primaryDark.withValues(alpha: 0.3)
                      : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              formattedDate,
              style: TextStyle(
                color: isDarkMode ? AppColors.grey300 : AppColors.textMedium,
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed:
                () => AppNavigator.push(
                  context,
                  NewOrdersDetailScreen(salesOrder: widget.salesOrder),
                ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color:
                    isDarkMode ? AppColors.primaryLight : AppColors.primaryBlue,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: FaIcon(
              FontAwesomeIcons.arrowRight,
              size: 16,
              color:
                  isDarkMode ? AppColors.primaryLight : AppColors.primaryBlue,
            ),
            label: Text(
              'Start Picking',
              style: TextStyle(
                color:
                    isDarkMode ? AppColors.primaryLight : AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewBadge() {
    return Positioned(
      top: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _blinkAnimation,
        builder: (context, child) {
          final blinkValue = _blinkAnimation.value;
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color.lerp(Colors.transparent, Colors.red, blinkValue),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red, width: 1.5),
            ),
            child: Text(
              'Nice',
              style: TextStyle(
                color: Color.lerp(Colors.red, Colors.white, blinkValue),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          );
        },
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

/// Helper class to manage card styling based on theme and status
class CardStyle {
  final Color shadowColor;
  final BorderSide borderSide;
  final Color backgroundColor;

  CardStyle({
    required this.shadowColor,
    required this.borderSide,
    required this.backgroundColor,
  });
}
