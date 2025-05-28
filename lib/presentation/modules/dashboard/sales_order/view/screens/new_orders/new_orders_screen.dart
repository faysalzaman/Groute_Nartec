import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_date_formatter.dart';
import 'package:groute_nartec/core/utils/app_loading.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/new_orders_map_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/orders_details_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/widgets/order_card_shimmer.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';

class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({super.key});

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  int page = 1;
  int limit = 10;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize bloc provider and load first page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SalesCubit>().getSalesOrder(page, limit);
    });
  }

  void _loadMore() {
    if (!isLoading) {
      setState(() {
        page++;
        isLoading = true;
      });
      context.read<SalesCubit>().getSalesOrder(page, limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final salesOrders = context.watch<SalesCubit>().salesOrders;
    return CustomScaffold(
      title: 'New Orders',
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[50]!, Colors.white],
          ),
        ),
        child: BlocConsumer<SalesCubit, SalesState>(
          listener: (context, state) {
            if (state is SalesLoaded) {
              setState(() {
                // If we're loading more, append to existing list, otherwise replace
                if (page > 1) {
                  salesOrders.addAll(state.salesOrders);
                } else {
                  salesOrders.clear();
                  salesOrders.addAll(state.salesOrders);
                }
                isLoading = false;
              });
            } else if (state is SalesError) {
              AppSnackbars.danger(
                context,
                state.error.replaceAll("Exception: ", ""),
              );
              setState(() {
                isLoading = false;
              });
            }
          },
          builder: (context, state) {
            if (state is SalesInitial) {
              return Center(child: AppLoading());
            } else if (state is SalesLoading && page == 1) {
              // Use the custom OrderCardShimmer for loading state
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: 5, // Show 5 placeholder items
                  itemBuilder: (context, index) {
                    return const OrderCardShimmer();
                  },
                ),
              );
            } else if (salesOrders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No orders available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'New orders will appear here',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 32),
                    CustomElevatedButton(
                      title: 'Refresh',
                      onPressed: () {
                        setState(() {
                          page = 1;
                        });
                        context.read<SalesCubit>().getSalesOrder(page, limit);
                      },
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ],
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    page = 1;
                    salesOrders.clear();
                  });
                  context.read<SalesCubit>().getSalesOrder(page, limit);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: salesOrders.length + 1, // +1 for load more button
                  itemBuilder: (context, index) {
                    if (index == salesOrders.length) {
                      // This is the last item, show load more button if needed
                      return salesOrders.length >= page * limit
                          ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CustomElevatedButton(
                                title: 'Load More Orders',
                                onPressed:
                                    state is SalesLoading ? null : _loadMore,
                                buttonState:
                                    state is SalesLoading
                                        ? ButtonState.loading
                                        : ButtonState.idle,
                                backgroundColor: AppColors.primaryBlue
                                    .withValues(alpha: 0.1),
                                foregroundColor: AppColors.primaryBlue,
                              ),
                            ),
                          )
                          : const SizedBox(height: 24); // No more items to load
                    } else {
                      // Regular item
                      return SalesOrderCard(salesOrder: salesOrders[index]);
                    }
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

// Convert SalesOrderCard to StatefulWidget
class SalesOrderCard extends StatefulWidget {
  final SalesOrderModel salesOrder;

  const SalesOrderCard({super.key, required this.salesOrder});

  @override
  State<SalesOrderCard> createState() => _SalesOrderCardState();
}

class _SalesOrderCardState extends State<SalesOrderCard>
    with TickerProviderStateMixin {
  bool _isProcessing = false; // State variable for loading indicator
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to handle location fetching and navigation
  Future<void> _processOrder(BuildContext context) async {
    if (!mounted) return; // Check if widget is still mounted

    // Animate button press
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

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
            'Location services are disabled. Please enable them.',
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
            AppSnackbars.danger(context, 'Location permissions are denied.');
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
            'Location permissions are permanently denied. Please enable them in settings.',
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
          AppSnackbars.danger(context, 'Invalid customer location data.');
        }
        setState(() {
          _isProcessing = false;
        });
        return;
      }
      LatLng destinationLocation = LatLng(customerLat, customerLng);

      // 4. Navigate to Map Screen
      if (mounted) {
        AppNavigator.push(
          context,
          NewOrdersMapScreen(
            salesOrder: widget.salesOrder,
            salesOrderLocation: destinationLocation,
            currentDeviceLocation: currentDeviceLocation,
          ),
        );
      }
    } catch (e) {
      // Handle potential errors during location fetching
      if (mounted) {
        AppSnackbars.danger(context, 'Failed to get location: $e');
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
    // Get item count
    final itemCount = widget.salesOrder.salesInvoiceDetails?.length ?? 0;

    // Get customer name and address
    final customerName =
        widget.salesOrder.customer?.companyNameEnglish ?? 'Unknown Customer';
    final deliveryAddress =
        widget.salesOrder.customer?.address ?? 'No address provided';

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status banner with gradient
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getStatusColor(widget.salesOrder.status),
                            _getStatusColor(
                              widget.salesOrder.status,
                            ).withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              _getStatusIcon(widget.salesOrder.status),
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.salesOrder.status?.toUpperCase() ?? 'NEW',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order header with better typography
                          Row(
                            children: [
                              Icon(
                                Icons.receipt_outlined,
                                size: 16,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Order #${widget.salesOrder.salesInvoiceNumber ?? 'N/A'}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.receipt_outlined,
                                size: 16,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Ref #${widget.salesOrder.refNo ?? 'N/A'}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$itemCount item${itemCount != 1 ? 's' : ''}',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Customer info card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.business,
                                      size: 16,
                                      color: AppColors.primaryBlue,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        customerName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        deliveryAddress,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                          height: 1.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Date information
                          Row(
                            children: [
                              Expanded(
                                child: _buildDateInfo(
                                  icon: Icons.calendar_today_outlined,
                                  label: "Delivery",
                                  date: widget.salesOrder.deliveryDate,
                                  color: Colors.green[600]!,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDateInfo(
                                  icon: Icons.schedule_outlined,
                                  label: "Order",
                                  date: widget.salesOrder.orderDate,
                                  color: Colors.blue[600]!,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Total amount with better styling
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryBlue.withValues(alpha: 0.1),
                                  AppColors.primaryBlue.withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${widget.salesOrder.totalAmount ?? 'N/A'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Enhanced action buttons
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border(
                          top: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed:
                                  _isProcessing
                                      ? null
                                      : () {
                                        AppNavigator.push(
                                          context,
                                          OrdersDetailScreen(
                                            salesOrder: widget.salesOrder,
                                          ),
                                        );
                                      },
                              icon: Icon(
                                Icons.visibility_outlined,
                                size: 18,
                                color:
                                    _isProcessing
                                        ? Colors.grey
                                        : AppColors.primaryBlue,
                              ),
                              label: Text(
                                'View Details',
                                style: TextStyle(
                                  color:
                                      _isProcessing
                                          ? Colors.grey
                                          : AppColors.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                side: BorderSide(
                                  color:
                                      _isProcessing
                                          ? Colors.grey[300]!
                                          : AppColors.primaryBlue,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: CustomElevatedButton(
                              height: 48,
                              onPressed:
                                  _isProcessing
                                      ? null
                                      : () => _processOrder(context),
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              title: 'Start Journey',

                              buttonState:
                                  _isProcessing
                                      ? ButtonState.loading
                                      : ButtonState.idle,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildDateInfo({
    required IconData icon,
    required String label,
    required String? date,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            date != null
                ? AppDateFormatter.fromString(date, showTime: true)
                : 'N/A',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    if (status == null)
      return Icons.help_outline; // Default icon for unknown status
    switch (status.toLowerCase()) {
      case 'new':
        return Icons.new_releases_outlined;
      case 'in progress':
        return Icons.hourglass_top_outlined;
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline; // Default icon for unknown status
    }
  }
}
