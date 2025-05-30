import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/loading/loading_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/widgets/scanned_item_card.dart';
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
  final TextEditingController _wipLocationController = TextEditingController();

  @override
  void initState() {
    LoadingCubit.get(context).init();
    super.initState();
  }

  @override
  void dispose() {
    _palletNumberController.dispose();
    _wipLocationController.dispose();
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

                // WIP Location input
                _buildWipLocationInput(isDark),
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
            Text(
              "Picked Quantity: ${LoadingCubit.get(context).salesInvoiceDetails?.quantityPicked ?? "0"}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
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
    final scannedItems = cubit.scannedItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed header section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Scanned Items (${scannedItems.length})",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            TextButton(
              onPressed: () {
                LoadingCubit.get(context).clearScannedItems();
              },
              child: const Text(
                "Clear All",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),

        // Scrollable content area
        Expanded(
          child:
              scannedItems.isEmpty
                  ? _buildEmptyScannedItems(isDark)
                  : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _buildScannedItemsList(isDark),
                  ),
        ),
      ],
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

  Widget _buildScannedItemsList(bool isDark) {
    final cubit = LoadingCubit.get(context);
    final scannedItems = cubit.scannedItems;

    return Column(
      children:
          scannedItems.entries.map((entry) {
            final String keyCode = entry.key;
            final List<Map<dynamic, dynamic>> items = entry.value;

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
                ...items.map((itemData) {
                  return ScannedItemCard(itemData: itemData);
                }).toList(),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildWipLocationInput(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Scan WIP Location",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextFormField(
          controller: _wipLocationController,
          hintText: "WIP Location",
          keyboardType: TextInputType.text,
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
        children: [
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                // Implement pick selected items functionality
              },
              title: "Pick selected Items",
              width: double.infinity,
              height: 40,
              backgroundColor: AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                // Implement save functionality
                Navigator.pop(context);
              },
              title: "Save",
              width: double.infinity,
              height: 40,
              backgroundColor: AppColors.secondary,
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
      cubit.scanPackagingBySscc(palletCode: _palletNumberController.text);
    } else {
      cubit.scanPackagingBySscc(serialNo: _palletNumberController.text);
    }
  }
}
