import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_loading.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/widgets/orders_card.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/widgets/orders_card_placeholder.dart';
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
              // Use the OrdersCardPlaceholder for loading state
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: 5, // Show 5 placeholder items
                  itemBuilder: (context, index) {
                    return const OrdersCardPlaceholder();
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
                      return OrdersCard(salesOrder: salesOrders[index]);
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
