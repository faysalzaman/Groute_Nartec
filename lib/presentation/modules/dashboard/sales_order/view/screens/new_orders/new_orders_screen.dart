import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart'; // Add this import
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/new_orders_map_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/orders_details_screen.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:intl/intl.dart';

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
  List<SalesOrderModel> salesOrders = [];

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
    return CustomScaffold(
      title: 'New Orders',
      body: BlocConsumer<SalesCubit, SalesState>(
        listener: (context, state) {
          if (state is SalesLoaded) {
            setState(() {
              // If we're loading more, append to existing list, otherwise replace
              if (page > 1) {
                salesOrders.addAll(state.salesOrders);
              } else {
                salesOrders = state.salesOrders;
              }
              isLoading = false;
            });
          } else if (state is SalesError) {
            // Show error message
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
            setState(() {
              isLoading = false;
            });
          }
        },
        builder: (context, state) {
          if (state is SalesLoading && page == 1) {
            // Replace simple CircularProgressIndicator with a placeholder loading UI
            return ListView.builder(
              itemCount: 5, // Show 5 placeholder items
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 150,
                                  height: 16,
                                  color: Colors.grey[200],
                                ),
                                Container(
                                  width: 80,
                                  height: 14,
                                  color: Colors.grey[200],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: 180,
                              height: 15,
                              color: Colors.grey[200],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              height: 14,
                              color: Colors.grey[200],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 80,
                                  height: 14,
                                  color: Colors.grey[200],
                                ),
                                Container(
                                  width: 100,
                                  height: 16,
                                  color: Colors.grey[200],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 80,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 80,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (salesOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No orders available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        page = 1;
                      });
                      context.read<SalesCubit>().getSalesOrder(page, limit);
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  page = 1;
                  salesOrders = [];
                });
                context.read<SalesCubit>().getSalesOrder(page, limit);
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: salesOrders.length + 1, // +1 for load more button
                itemBuilder: (context, index) {
                  if (index == salesOrders.length) {
                    // This is the last item, show load more button if needed
                    return salesOrders.length >= page * limit
                        ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: ElevatedButton(
                              onPressed:
                                  state is SalesLoading ? null : _loadMore,
                              child:
                                  state is SalesLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : const Text('Load More'),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(); // No more items to load
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location services are disabled. Please enable them.',
              ),
            ),
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied.')),
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location permissions are permanently denied. Please enable them in settings.',
              ),
            ),
          );
          // Optionally, prompt user to open settings:
          // await Geolocator.openAppSettings();
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid customer location data.')),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
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
    // Format date
    String formattedDate = 'N/A';
    if (widget.salesOrder.orderDate != null) {
      try {
        final dateTime = DateTime.parse(widget.salesOrder.orderDate!);
        formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.salesOrder.status),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              widget.salesOrder.status?.toUpperCase() ?? 'NEW',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order number and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Order #${widget.salesOrder.salesInvoiceNumber ?? 'N/A'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Customer details
                Text(
                  customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  deliveryAddress,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Order summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$itemCount item${itemCount != 1 ? 's' : ''}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      'Total: ${widget.salesOrder.totalAmount ?? 'N/A'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  // Disable button while processing
                  onPressed:
                      _isProcessing
                          ? null
                          : () {
                            AppNavigator.push(
                              context,
                              OrdersDetailScreen(salesOrder: widget.salesOrder),
                            );
                          },
                  child: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                CustomElevatedButton(
                  width: 100,
                  height: 40,
                  onPressed:
                      _isProcessing ? null : () => _processOrder(context),
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  title: 'Process',
                  buttonState:
                      _isProcessing ? ButtonState.loading : ButtonState.idle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.blue;

    switch (status.toLowerCase()) {
      case 'new':
      case 'pending':
        return Colors.blue;
      case 'processing':
      case 'in progress':
        return Colors.orange;
      case 'completed':
      case 'delivered':
        return Colors.green;
      case 'cancelled':
      case 'failed':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
