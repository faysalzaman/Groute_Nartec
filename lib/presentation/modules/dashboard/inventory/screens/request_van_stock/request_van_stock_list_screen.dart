import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class _RequestVanStockListScreenState extends State<RequestVanStockListScreen>
    with TickerProviderStateMixin {
  // Controllers for text fields
  final TextEditingController _palletNumberController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    RequestStockCubit.get(context).init();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _palletNumberController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomScaffold(
      title: "Request Van Stock",
      automaticallyImplyLeading: true,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    isDark
                        ? [
                          AppColors.darkBackground,
                          AppColors.darkBackground.withValues(alpha: 0.8),
                        ]
                        : [AppColors.lightBackground, Colors.grey[50]!],
              ),
            ),
            child: BlocConsumer<RequestStockCubit, RequestStockState>(
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
                      current is RequestStockScanItemLoaded ||
                      current is RequestStockAddRequestItemLoaded,
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header section with stats
                      _buildHeaderSection(isDark),

                      const SizedBox(height: 20),

                      // Add items button with enhanced styling
                      _buildAddItemsButton(isDark),

                      const SizedBox(height: 20),

                      // Scanned items section with enhanced styling
                      Expanded(child: _buildScannedItemsSection(isDark)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildHeaderSection(bool isDark) {
    final cubit = RequestStockCubit.get(context);
    final totalItems = cubit.productOnPalletsAdded.values.fold<int>(
      0,
      (sum, items) => sum + items.length,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    AppColors.primaryDark.withValues(alpha: 0.2),
                    AppColors.primaryBlue.withValues(alpha: 0.1),
                  ]
                  : [
                    AppColors.primaryBlue.withValues(alpha: 0.1),
                    AppColors.primaryLight.withValues(alpha: 0.05),
                  ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDark
                  ? AppColors.primaryLight.withValues(alpha: 0.2)
                  : AppColors.primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.primaryDark : AppColors.primaryBlue)
                .withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? AppColors.primaryLight.withValues(alpha: 0.1)
                      : AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(
              FontAwesomeIcons.boxesStacked,
              color: isDark ? AppColors.primaryLight : AppColors.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Items in Request",
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isDark
                            ? AppColors.textLight.withValues(alpha: 0.7)
                            : AppColors.textMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$totalItems Items",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:
                        isDark ? AppColors.primaryLight : AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          if (totalItems > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Ready",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddItemsButton(bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: CustomElevatedButton(
        title: "Add New Items",
        width: double.infinity,
        height: 56,
        backgroundColor: AppColors.orange,
        onPressed: () {
          AppNavigator.push(context, RequestVanStockScreen());
        },
        // borderRadius: 16,
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const FaIcon(FontAwesomeIcons.plus, color: Colors.white, size: 18),
        //     const SizedBox(width: 12),
        //     const Text(
        //       "Add New Items",
        //       style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.w600,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Widget _buildScannedItemsSection(bool isDark) {
    final cubit = RequestStockCubit.get(context);
    final productOnPallets = cubit.productOnPalletsAdded;

    return BlocBuilder<RequestStockCubit, RequestStockState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color:
                isDark
                    ? AppColors.grey900.withValues(alpha: 0.3)
                    : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isDark
                      ? AppColors.grey700.withValues(alpha: 0.5)
                      : AppColors.grey300.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? AppColors.grey800.withValues(alpha: 0.3)
                          : AppColors.grey50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.listCheck,
                      size: 18,
                      color:
                          isDark
                              ? AppColors.primaryLight
                              : AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Requested Items",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child:
                    productOnPallets.isEmpty
                        ? _buildEmptyScannedItems(isDark)
                        : Padding(
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: _buildScannedItemsList(isDark),
                          ),
                        ),
              ),
            ],
          ),
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
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? AppColors.grey800.withValues(alpha: 0.3)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDark
                              ? AppColors.primaryLight.withValues(alpha: 0.2)
                              : AppColors.primaryBlue.withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.1 : 0.03,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Package header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.primaryDark.withValues(alpha: 0.2)
                                  : AppColors.primaryBlue.withValues(
                                    alpha: 0.05,
                                  ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? AppColors.primaryLight.withValues(
                                          alpha: 0.1,
                                        )
                                        : AppColors.primaryBlue.withValues(
                                          alpha: 0.1,
                                        ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.box,
                                size: 16,
                                color:
                                    isDark
                                        ? AppColors.primaryLight
                                        : AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Package Code",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          isDark
                                              ? AppColors.textLight.withValues(
                                                alpha: 0.7,
                                              )
                                              : AppColors.textMedium,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    keyCode,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isDark
                                              ? AppColors.primaryLight
                                              : AppColors.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.info.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.info.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                "${items.length} items",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.info,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Items list
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children:
                              items.map((item) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ProductOnPalletCard(
                                    item: item,
                                    isSelected: true,
                                    onSelectionChanged: (selected) {
                                      // cubit.toggleItemSelection(keyCode, itemId);
                                    },
                                    onRemove: () {
                                      cubit.removeItemFromRequestList(
                                        keyCode,
                                        item,
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
    );
  }

  Widget _buildEmptyScannedItems(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? AppColors.grey700.withValues(alpha: 0.3)
                      : AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              FontAwesomeIcons.boxOpen,
              size: 48,
              color:
                  isDark
                      ? AppColors.textLight.withValues(alpha: 0.5)
                      : AppColors.textMedium.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No items added yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color:
                  isDark
                      ? AppColors.textLight.withValues(alpha: 0.8)
                      : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap 'Add New Items' to start building your request",
            style: TextStyle(
              fontSize: 14,
              color:
                  isDark
                      ? AppColors.textLight.withValues(alpha: 0.6)
                      : AppColors.textMedium.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.lightbulb,
                  size: 14,
                  color: AppColors.info,
                ),
                const SizedBox(width: 8),
                Text(
                  "Use the button above to add items",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CustomElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: "Back",
                  width: double.infinity,
                  height: 48,
                  backgroundColor: AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BlocConsumer<RequestStockCubit, RequestStockState>(
                listener: (context, state) {
                  if (state is RequestStockRequestItemsLoaded) {
                    AppSnackbars.success(
                      context,
                      "Items requested successfully",
                    );
                    Navigator.pop(context);
                  } else if (state is RequestStockRequestItemsError) {
                    AppSnackbars.danger(context, state.message);
                  }
                },
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow:
                          RequestStockCubit.get(
                                context,
                              ).productOnPalletsAdded.isNotEmpty
                              ? [
                                BoxShadow(
                                  color: AppColors.success.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                              : [],
                    ),
                    child: CustomElevatedButton(
                      onPressed:
                          RequestStockCubit.get(
                                context,
                              ).productOnPalletsAdded.isNotEmpty
                              ? () {
                                RequestStockCubit.get(context).requestItems();
                              }
                              : null,
                      title: "Submit Request",
                      width: double.infinity,
                      height: 48,
                      backgroundColor:
                          RequestStockCubit.get(
                                context,
                              ).productOnPalletsAdded.isNotEmpty
                              ? AppColors.success
                              : AppColors.grey400,
                      buttonState:
                          state is RequestStockRequestItemsLoading
                              ? ButtonState.loading
                              : RequestStockCubit.get(
                                context,
                              ).productOnPalletsAdded.isNotEmpty
                              ? ButtonState.idle
                              : ButtonState.disabled,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
