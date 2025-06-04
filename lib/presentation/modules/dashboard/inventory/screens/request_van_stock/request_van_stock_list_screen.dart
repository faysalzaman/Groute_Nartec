import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/cubit/request_stock/request_stock_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/screens/request_van_stock/request_van_stock_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/product_on_pallet.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/widgets/product_on_pallet_card.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';

class RequestVanStockListScreen extends StatefulWidget {
  const RequestVanStockListScreen({super.key});

  @override
  State<RequestVanStockListScreen> createState() =>
      _RequestVanStockListScreenState();
}

class _RequestVanStockListScreenState extends State<RequestVanStockListScreen> {
  // Controllers for text fields
  final TextEditingController _palletNumberController = TextEditingController();

  @override
  void initState() {
    RequestStockCubit.get(context).init();
    super.initState();
  }

  @override
  void dispose() {
    _palletNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomScaffold(
      title: "Request Van Stock",
      automaticallyImplyLeading: true,
      body: BlocConsumer<RequestStockCubit, RequestStockState>(
        listenWhen:
            (previous, current) =>
                current is RequestStockScanItemError ||
                current is RequestStockScanItemLoaded,
        listener: (context, state) {
          if (state is RequestStockScanItemError) {
            AppSnackbars.danger(context, state.message);
            // Clear the input field after error
            _palletNumberController.clear();
          } else if (state is RequestStockScanItemLoaded) {
            // Clear the input field after successful scan
            _palletNumberController.clear();
          }
        },
        buildWhen:
            (previous, current) =>
                current is RequestStockChangeScanType ||
                current is RequestStockScanItemLoaded,
        builder: (context, state) {
          return Container(
            color:
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                CustomElevatedButton(
                  title: "Add Items",
                  width: double.infinity,
                  height: 50,
                  backgroundColor: AppColors.orange,
                  onPressed: () {
                    AppNavigator.push(context, RequestVanStockScreen());
                  },
                ),

                // Scanned items section - only this part should scroll
                Expanded(child: _buildScannedItemsSection(isDark)),

                const SizedBox(height: 8.0),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildScannedItemsSection(bool isDark) {
    final cubit = RequestStockCubit.get(context);
    final productOnPallets = cubit.productOnPallets;
    final totalItems = cubit.totalItemsCount;

    return BlocBuilder<RequestStockCubit, RequestStockState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  productOnPallets.isEmpty
                      ? _buildEmptyScannedItems(isDark)
                      : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: _buildScannedItemsList(isDark),
                      ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScannedItemsList(bool isDark) {
    final cubit = RequestStockCubit.get(context);
    final productOnPallets = cubit.productOnPalletsAdded;

    return Column(
      children:
          productOnPallets.entries.map((entry) {
            final String keyCode = entry.key;
            final List<ProductOnPallet> items = entry.value;

            return BlocBuilder<RequestStockCubit, RequestStockState>(
              buildWhen:
                  (previous, current) =>
                      current is RequestStockSelectionChanged ||
                      current is RequestStockItemRemoved ||
                      current is RequestStockAddRequestItemLoaded,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Package: $keyCode (${items.length} items)",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark
                                  ? AppColors.primaryLight
                                  : AppColors.primaryBlue,
                        ),
                      ),
                    ),
                    ...items.map((item) {
                      // Generate a unique identifier for this item
                      final String itemId =
                          item.id ?? '${item.serialNumber}-${item.palletId}';

                      return ProductOnPalletCard(
                        item: item,
                        isSelected: true,
                        onSelectionChanged: (selected) {
                          // cubit.toggleItemSelection(keyCode, itemId);
                        },
                        onRemove: () {
                          cubit.removeItem(keyCode, item);
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                  ],
                );
              },
            );
          }).toList(),
    );
  }

  Widget _buildEmptyScannedItems(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            isDark
                ? AppColors.grey900.withValues(alpha: 0.5)
                : AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.grey800 : AppColors.grey300,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color:
                isDark
                    ? AppColors.textLight.withValues(alpha: 0.5)
                    : AppColors.textMedium.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            "No items scanned yet",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color:
                  isDark
                      ? AppColors.textLight.withValues(alpha: 0.7)
                      : AppColors.textMedium,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Scan a pallet or serial number to add items",
            style: TextStyle(
              fontSize: 14,
              color:
                  isDark
                      ? AppColors.textLight.withValues(alpha: 0.5)
                      : AppColors.textMedium.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              title: "Back",
              width: double.infinity,
              height: 40,
              backgroundColor: AppColors.secondary,
            ),
          ),
          Expanded(
            child: BlocConsumer<RequestStockCubit, RequestStockState>(
              listener: (context, state) {
                if (state is RequestStockRequestItemsLoaded) {
                  AppSnackbars.success(context, "Items requested successfully");
                  Navigator.pop(context);
                } else if (state is RequestStockRequestItemsError) {
                  AppSnackbars.danger(context, state.message);
                }
              },
              builder: (context, state) {
                return CustomElevatedButton(
                  onPressed: () {
                    RequestStockCubit.get(context).requestItems();
                  },
                  title: "Submit Request",
                  width: double.infinity,
                  height: 40,
                  backgroundColor: AppColors.success,
                  buttonState:
                      state is RequestStockRequestItemsLoading
                          ? ButtonState.loading
                          : ButtonState.idle,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
