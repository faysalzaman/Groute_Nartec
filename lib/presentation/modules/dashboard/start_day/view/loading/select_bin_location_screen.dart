import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_loading.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/loading/loading_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/loading/pick_items_screen.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:groute_nartec/presentation/widgets/dropdowns/app_dropdown.dart';
import 'package:groute_nartec/presentation/widgets/text_fields/custom_textfield.dart';

class SelectBinLocationScreen extends StatefulWidget {
  const SelectBinLocationScreen({super.key});

  @override
  State<SelectBinLocationScreen> createState() =>
      _SelectBinLocationScreenState();
}

class _SelectBinLocationScreenState extends State<SelectBinLocationScreen> {
  // Controllers for text fields

  final TextEditingController _availableQuantityController =
      TextEditingController();
  final TextEditingController _whLocationCodeController = TextEditingController(
    text: "1106",
  );
  final TextEditingController _minQtyController = TextEditingController(
    text: "0",
  );
  final TextEditingController _maxQtyController = TextEditingController();
  final TextEditingController _itemBinTypeController = TextEditingController(
    text: "x",
  );
  final TextEditingController _locationCodeController = TextEditingController();

  // Dropdown options

  String? _selectedBinLocation;

  @override
  void initState() {
    super.initState();
    LoadingCubit.get(context).getSuggestedBinLocations();
  }

  @override
  void dispose() {
    _availableQuantityController.dispose();
    _whLocationCodeController.dispose();
    _minQtyController.dispose();
    _maxQtyController.dispose();
    _itemBinTypeController.dispose();
    _locationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Suggested Bin Number",
      automaticallyImplyLeading: true,
      body: Container(
        color: AppColors.lightBackground,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bin Number Display
                _buildBinNumberSection(),
                const SizedBox(height: 24),

                // Bin Locations Dropdown
                _buildBinLocationsSection(),
                const SizedBox(height: 16),

                // Details Fields
                _buildDetailsSection(),

                // Next Button
                const SizedBox(height: 24),
                _buildNextButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBinNumberSection() {
    final selectedSalesInvoiceDetails =
        LoadingCubit.get(context).salesInvoiceDetails;
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            selectedSalesInvoiceDetails?.productId ?? "",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          Text(
            selectedSalesInvoiceDetails?.productName ?? "",
            style: const TextStyle(fontSize: 16, color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildBinLocationsSection() {
    final _binLocations = LoadingCubit.get(context).binLocations;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Suggested Bin Locations",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<LoadingCubit, LoadingState>(
          builder: (context, state) {
            if (state is BinLocationLoading) {
              return const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Loading..."),
                    AppLoading(color: AppColors.primaryBlue),
                  ],
                ),
              );
            }
            return AppDropdown<String>(
              items:
                  _binLocations
                      .map((binLocation) => binLocation.binNumber)
                      .toList(),
              hintText: "Select Bin Location",
              initialItem: _selectedBinLocation,
              onChanged: (value) {
                LoadingCubit.get(context).setSelectedBinLocation(value);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailField(
          label: "Group Code",
          controller: TextEditingController(text: "Riyadh"),
          enabled: false,
        ),
        const SizedBox(height: 16),
        _buildDetailField(
          label: "Available Quantity",
          controller: _availableQuantityController,
          enabled: false,
        ),
        const SizedBox(height: 16),
        _buildDetailField(
          label: "WH Location Code",
          controller: _whLocationCodeController,
          enabled: false,
        ),
        const SizedBox(height: 16),
        _buildDetailField(
          label: "Min Qty",
          controller: _minQtyController,
          enabled: false,
        ),
        const SizedBox(height: 16),
        _buildDetailField(
          label: "Max Qty",
          controller: _maxQtyController,
          enabled: false,
        ),
        const SizedBox(height: 16),
        _buildDetailField(
          label: "Item Bin Type",
          controller: _itemBinTypeController,
          enabled: false,
        ),
        const SizedBox(height: 16),
        _buildScanLocationField(),
      ],
    );
  }

  Widget _buildDetailField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return CustomTextFormField(
      controller: controller,
      hintText: label,
      labelText: label,
      enabled: enabled,
    );
  }

  Widget _buildScanLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Enter / Scan Location Code",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: _locationCodeController,
                hintText: "Enter or scan location code",
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  // Implement scan functionality
                },
                icon: const Icon(Icons.qr_code_scanner, color: AppColors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return CustomElevatedButton(
      onPressed: () {
        AppNavigator.push(context, PickItemsScreen());
      },
      title: "Next",
      width: double.infinity,
      height: 50,
    );
  }
}
