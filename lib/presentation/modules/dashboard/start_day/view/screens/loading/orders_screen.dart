import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/utils/app_loading.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/widgets/order_card_shimmer.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/widgets/sales_order_card.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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
      title: 'Loading / Unloading',
      body: BlocConsumer<SalesCubit, SalesState>(
        listener: (context, state) {
          if (state is SalesError) {
            AppSnackbars.danger(
              context,
              state.error.replaceAll("Exception: ", ""),
            );
          }
        },
        builder: (context, state) {
          if (state is SalesInitial) {
            return Center(child: AppLoading());
          } else if (state is SalesLoading && page == 1) {
            // Use the custom OrderCardShimmer for loading state
            return ListView.builder(
              itemCount: 5, // Show 5 placeholder items
              itemBuilder: (context, index) {
                return const OrderCardShimmer();
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
                  salesOrders.clear();
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
                            child: CustomElevatedButton(
                              title: 'Load More',
                              onPressed:
                                  state is SalesLoading ? null : _loadMore,
                              buttonState:
                                  state is SalesLoading
                                      ? ButtonState.loading
                                      : ButtonState.idle,
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
