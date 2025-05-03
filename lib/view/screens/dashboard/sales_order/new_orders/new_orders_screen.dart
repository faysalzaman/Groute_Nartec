import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/cubit/sales_cubit.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/cubit/sales_state.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/new_orders/new_orders_detail_screen.dart';
import 'package:groute_nartec/view/widgets/custom_scaffold.dart';
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
          if (state is SalesInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SalesLoading && page == 1) {
            return const Center(child: CircularProgressIndicator());
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

class SalesOrderCard extends StatelessWidget {
  final SalesOrderModel salesOrder;

  const SalesOrderCard({super.key, required this.salesOrder});

  @override
  Widget build(BuildContext context) {
    // Format date
    String formattedDate = 'N/A';
    if (salesOrder.orderDate != null) {
      try {
        final dateTime = DateTime.parse(salesOrder.orderDate!);
        formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
      } catch (e) {
        formattedDate = salesOrder.orderDate ?? 'N/A';
      }
    }

    // Get item count
    final itemCount = salesOrder.salesInvoiceDetails?.length ?? 0;

    // Get customer name and address
    final customerName =
        salesOrder.customer?.companyNameEnglish ?? 'Unknown Customer';
    final deliveryAddress =
        salesOrder.customer?.address ?? 'No address provided';

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
              color: _getStatusColor(salesOrder.status),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              salesOrder.status?.toUpperCase() ?? 'NEW',
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
                        'Order #${salesOrder.salesInvoiceNumber ?? 'N/A'}',
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
                      'Total: ${salesOrder.totalAmount ?? 'N/A'}',
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
                  onPressed: () {
                    AppNavigator.push(
                      context,
                      NewOrdersDetailScreen(salesOrder: salesOrder),
                    );
                  },
                  child: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Process order action
                  },
                  child: const Text('Process'),
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
