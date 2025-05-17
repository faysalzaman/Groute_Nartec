import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/loading/loading_cubit.dart';
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

  // State variables

  int _quantity = 5;
  int _pickedQuantity = 0;
  List<ScannedItem> _scannedItems = [];

  @override
  void initState() {
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
      body: Container(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        child: BlocBuilder<LoadingCubit, LoadingState>(
          buildWhen: (previous, current) => current is ChangeScanType,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                // Quantity information
                _buildQuantityInfo(isDark),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.grey700 : AppColors.grey300,
                ),

                // Scan type selection
                _buildScanTypeSelection(isDark),

                // Pallet number input
                _buildPalletNumberInput(isDark),

                // Scanned items section
                Expanded(child: _buildScannedItemsSection(isDark)),

                // WIP Location input
                _buildWipLocationInput(isDark),
                const SizedBox(height: 8.0),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildQuantityInfo(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Quantity: $_quantity",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        Text(
          "Picked Quantity: $_pickedQuantity",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildScanTypeSelection(bool isDark) {
    return Row(
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
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isSelected
                        ? AppColors.secondary
                        : (isDark ? AppColors.grey600 : AppColors.grey400),
                width: 2,
              ),
            ),
            child:
                isSelected
                    ? Container(
                      margin: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary,
                      ),
                    )
                    : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color:
                  isSelected
                      ? (isDark ? AppColors.textLight : AppColors.textDark)
                      : (isDark
                          ? AppColors.textLight.withAlpha(128)
                          : AppColors.textMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPalletNumberInput(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LoadingCubit.get(context).byPallet
              ? "Scan Pallet Number"
              : "Scan Serial Number",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: _palletNumberController,
                hintText:
                    LoadingCubit.get(context).byPallet
                        ? "Scan Pallet Number"
                        : "Scan Serial Number",
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey800 : AppColors.grey200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: BlocConsumer<LoadingCubit, LoadingState>(
                listener: (context, state) {
                  if (state is ScanItemError) {
                    AppSnackbars.danger(context, state.message);
                  }
                },
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      // Implement scan functionality
                      LoadingCubit.get(context).scanPackagingBySscc(
                        palletCode: _palletNumberController.text,
                        serialNo: _palletNumberController.text,
                      );
                    },
                    icon: FaIcon(
                      state is ScanItemLoading
                          ? FontAwesomeIcons.hourglass
                          : FontAwesomeIcons.qrcode,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScannedItemsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Scanned Items (${_scannedItems.length})",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _scannedItems.clear();
                });
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
        const SizedBox(height: 16),
        _scannedItems.isEmpty
            ? _buildEmptyScannedItems(isDark)
            : _buildScannedItemsList(isDark),
      ],
    );
  }

  Widget _buildEmptyScannedItems(bool isDark) {
    return Container(
      width: double.infinity,
      height: 120,
      alignment: Alignment.center,
      child: Text(
        "No items scanned yet",
        style: TextStyle(
          fontSize: 16,
          color:
              isDark
                  ? AppColors.textLight.withAlpha(128)
                  : AppColors.textMedium,
        ),
      ),
    );
  }

  Widget _buildScannedItemsList(bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _scannedItems.length,
      itemBuilder: (context, index) {
        final item = _scannedItems[index];
        return ListTile(
          title: Text(
            item.name,
            style: TextStyle(
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          subtitle: Text(
            item.code,
            style: TextStyle(
              color:
                  isDark
                      ? AppColors.textLight.withAlpha(128)
                      : AppColors.textMedium,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: AppColors.error),
            onPressed: () {
              setState(() {
                _scannedItems.removeAt(index);
              });
            },
          ),
        );
      },
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
        spacing: 16,
        children: [
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                // Implement pick selected items functionality
              },
              title: "Pick selected Items",
              width: double.infinity,
              height: 50,
              backgroundColor: AppColors.success,
            ),
          ),
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                // Implement save functionality
                Navigator.pop(context);
              },
              title: "Save",
              width: double.infinity,
              height: 50,
              backgroundColor: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

// Model class for scanned items
class ScannedItem {
  final String name;
  final String code;

  ScannedItem({required this.name, required this.code});
}
