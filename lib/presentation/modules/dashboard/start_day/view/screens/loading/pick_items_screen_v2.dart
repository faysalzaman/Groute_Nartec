import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/loading/loading_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/product_on_pallet.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/screens/loading/orders_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/widgets/product_on_pallet_card.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:groute_nartec/presentation/widgets/text_fields/custom_textfield.dart';

class PickItemsScreen extends StatefulWidget {
  const PickItemsScreen({super.key});

  @override
  State<PickItemsScreen> createState() => _PickItemsScreenState();
}

class _PickItemsScreenState extends State<PickItemsScreen> {
  // Controllers for text fields
  final TextEditingController _palletNumberController = TextEditingController();
  final TextEditingController _binNumberController = TextEditingController();

  @override
  void initState() {
    LoadingCubit.get(context).init();
    super.initState();
  }

  @override
  void dispose() {
    _palletNumberController.dispose();
    _binNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomScaffold(
      title: "Scan By Serial | Pallet",
      automaticallyImplyLeading: true,
      body: BlocConsumer<LoadingCubit, LoadingState>(
        listenWhen:
            (previous, current) =>
                current is ScanItemError || current is ScanItemLoaded,
        listener: (context, state) {
          if (state is ScanItemError) {
            AppSnackbars.danger(context, state.message);
            // Clear the input field after error
            _palletNumberController.clear();
          } else if (state is ScanItemLoaded) {
            // Clear the input field after successful scan
            _palletNumberController.clear();
          }
        },
        buildWhen:
            (previous, current) =>
                current is ChangeScanType || current is ScanItemLoaded,
        builder: (context, state) {
          return Container(
            color:
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                // Quantity information
                _buildQuantityInfo(isDark),

                // Scan type selection
                _buildScanTypeSelection(isDark),

                // Pallet number input
                _buildPalletNumberInput(isDark),

                // Scanned items section - only this part should scroll
                Expanded(child: _buildScannedItemsSection(isDark)),

                // // WIP Location input
                _buildVehicleLocationScanInput(isDark),
                const SizedBox(height: 8.0),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildQuantityInfo(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Quantity: ${LoadingCubit.get(context).salesInvoiceDetails?.quantity}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            BlocBuilder<LoadingCubit, LoadingState>(
              buildWhen: (previous, current) => current is SelectionChanged,
              builder: (context, state) {
                return Text(
                  "Picked Quantity: ${LoadingCubit.get(context).quantityPicked}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                );
              },
            ),
          ],
        ),
        const Divider(height: 1, color: AppColors.grey300),
      ],
    );
  }

  Widget _buildScanTypeSelection(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildScanTypeOption(
          label: "BY PALLET",
          isSelected: LoadingCubit.get(context).byPallet,
          isDark: isDark,
          onTap: () {
            LoadingCubit.get(context).setScanType(true, false);
          },
        ),
        const SizedBox(width: 24),
        _buildScanTypeOption(
          label: "BY SERIAL",
          isSelected: LoadingCubit.get(context).bySerial,
          isDark: isDark,
          onTap: () {
            LoadingCubit.get(context).setScanType(false, true);
          },
        ),
      ],
    );
  }

  Widget _buildScanTypeOption({
    required String label,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final primaryColor =
        isDark ? AppColors.primaryLight : AppColors.primaryBlue;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? primaryColor.withValues(alpha: isDark ? 0.2 : 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? primaryColor
                    : isDark
                    ? AppColors.grey700
                    : AppColors.grey300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color:
                isSelected
                    ? primaryColor
                    : isDark
                    ? AppColors.textLight
                    : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildPalletNumberInput(bool isDark) {
    final bool byPallet = LoadingCubit.get(context).byPallet;
    final String hintText =
        byPallet ? "Enter Pallet/SSCC Number" : "Enter Serial Number";
    final String labelText = byPallet ? "Pallet/SSCC Number" : "Serial Number";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: _palletNumberController,
                hintText: hintText,
                labelText: labelText,
                keyboardType: TextInputType.text,
                onCompleted: _scanItem,
              ),
            ),
            const SizedBox(width: 16),
            BlocBuilder<LoadingCubit, LoadingState>(
              buildWhen:
                  (previous, current) =>
                      current is ScanItemLoading ||
                      current is ScanItemLoaded ||
                      current is ScanItemError,
              builder: (context, state) {
                final isLoading = state is ScanItemLoading;

                return CircleAvatar(
                  backgroundColor:
                      isDark ? AppColors.grey700 : AppColors.grey300,
                  radius: 25,
                  child: IconButton(
                    icon: FaIcon(
                      isLoading
                          ? FontAwesomeIcons.spinner
                          : FontAwesomeIcons.qrcode,
                    ),
                    onPressed: isLoading ? null : _scanItem,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScannedItemsSection(bool isDark) {
    final cubit = LoadingCubit.get(context);
    final productOnPallets = cubit.productOnPallets;
    final totalItems = cubit.totalItemsCount;

    return BlocBuilder<LoadingCubit, LoadingState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with item count and select all option
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Item count
                  Text(
                    "Items: ${cubit.totalSelectedItemsCount}/$totalItems (Max: ${cubit.salesInvoiceDetails?.quantity})",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  // Select All button
                  BlocBuilder<LoadingCubit, LoadingState>(
                    buildWhen:
                        (previous, current) =>
                            current is SelectionChanged ||
                            current is ItemRemoved,
                    builder: (context, state) {
                      final bool allSelected = cubit.areAllItemsSelected();
                      return GestureDetector(
                        onTap: () {
                          if (allSelected) {
                            cubit.clearSelectedItems();
                          } else {
                            cubit.selectAllItems();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                allSelected
                                    ? (isDark
                                        ? AppColors.primaryDark.withValues(
                                          alpha: 0.6,
                                        )
                                        : AppColors.primaryLight.withValues(
                                          alpha: 0.1,
                                        ))
                                    : (isDark
                                        ? AppColors.primaryLight.withValues(
                                          alpha: 0.1,
                                        )
                                        : AppColors.primaryBlue.withValues(
                                          alpha: 0.1,
                                        )),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isDark
                                      ? AppColors.primaryLight.withValues(
                                        alpha: 0.5,
                                      )
                                      : AppColors.primaryBlue.withValues(
                                        alpha: 0.5,
                                      ),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                allSelected
                                    ? Icons.deselect_outlined
                                    : Icons.select_all_outlined,
                                size: 16,
                                color:
                                    isDark
                                        ? AppColors.primaryLight
                                        : AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                allSelected ? "Deselect All" : "Select All",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isDark
                                          ? AppColors.primaryLight
                                          : AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Clear all button if there are items
            if (totalItems > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: () => cubit.clearScannedItems(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? AppColors.error.withValues(alpha: 0.1)
                              : AppColors.error.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            isDark
                                ? AppColors.error.withValues(alpha: 0.5)
                                : AppColors.error.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete_sweep_outlined,
                          size: 16,
                          color:
                              isDark
                                  ? AppColors.error.withValues(alpha: 0.9)
                                  : AppColors.error,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Clear All",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                isDark
                                    ? AppColors.error.withValues(alpha: 0.9)
                                    : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
    final cubit = LoadingCubit.get(context);
    final productOnPallets = cubit.productOnPallets;

    return Column(
      children:
          productOnPallets.entries.map((entry) {
            final String keyCode = entry.key;
            final List<ProductOnPallet> items = entry.value;

            return BlocBuilder<LoadingCubit, LoadingState>(
              buildWhen:
                  (previous, current) =>
                      current is SelectionChanged || current is ItemRemoved,
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
                        isSelected: cubit.isItemSelected(keyCode, itemId),
                        onSelectionChanged: (selected) {
                          cubit.toggleItemSelection(keyCode, itemId);
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

  Widget _buildVehicleLocationScanInput(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Scan Vehile Location",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        BlocConsumer<LoadingCubit, LoadingState>(
          buildWhen:
              (previous, current) =>
                  current is ScanBinLocationLoading ||
                  current is ScanBinLocationLoaded ||
                  current is ScanBinLocationError,
          listener: (context, state) {
            if (state is ScanBinLocationLoaded) {
              AppSnackbars.success(context, state.message);
              //   _binNumberController.clear();
            }
          },
          builder: (context, state) {
            return CustomTextFormField(
              controller: _binNumberController,
              hintText: "Vehicle Location",
              keyboardType: TextInputType.text,
              suffixIcon:
                  state is ScanBinLocationLoading
                      ? FontAwesomeIcons.circle
                      : FontAwesomeIcons.qrcode,
              onSuffixIconPressed: () {
                // Implement scan functionality
                if (_binNumberController.text.isEmpty) {
                  AppSnackbars.warning(context, "Please enter a value to scan");
                  return;
                }
                LoadingCubit.get(
                  context,
                ).scanVehicleLocation(_binNumberController.text);
              },
            );
          },
        ),
      ],
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
                // Implement save functionality
                Navigator.pop(context);
              },
              title: "Back",
              width: double.infinity,
              height: 40,
              backgroundColor: AppColors.secondary,
            ),
          ),
          Expanded(
            child: BlocConsumer<LoadingCubit, LoadingState>(
              listener: (context, state) {
                if (state is PickItemsLoaded) {
                  AppSnackbars.success(context, "Items picked successfully");
                  Navigator.pop(context); // go to bin location screen
                  Navigator.pop(context); // go to gs1 details screen
                  Navigator.pop(context); // go to sales invoice details screen
                  Navigator.pop(context); // go to sales orders
                  LoadingCubit.get(context).clearDeliveryDetails();
                  AppNavigator.pushReplacement(context, OrdersScreen());
                } else if (state is PickItemsError) {
                  AppSnackbars.danger(context, state.message);
                }
              },
              builder: (context, state) {
                return CustomElevatedButton(
                  onPressed: () {
                    // Implement pick selected items functionality
                    if (LoadingCubit.get(
                      context,
                    ).selectedItems.values.isEmpty) {
                      AppSnackbars.warning(
                        context,
                        "Please select items to pick",
                      );
                      return;
                    }

                    LoadingCubit.get(context).pickItems();
                  },
                  title: "Submit",
                  width: double.infinity,
                  height: 40,
                  backgroundColor: AppColors.success,
                  buttonState:
                      LoadingCubit.get(context).isSaveButtonEnabled == false
                          ? ButtonState.disabled
                          : state is PickItemsLoading
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

  void _scanItem() {
    if (_palletNumberController.text.isEmpty) {
      AppSnackbars.warning(context, "Please enter a value to scan");
      return;
    }

    final LoadingCubit cubit = LoadingCubit.get(context);
    final bool byPallet = cubit.byPallet;

    if (byPallet) {
      cubit.scanBySerialOrPallet(palletCode: _palletNumberController.text);
    } else {
      cubit.scanBySerialOrPallet(serialNo: _palletNumberController.text);
    }
  }
}
