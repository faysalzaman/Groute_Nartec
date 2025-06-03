import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/cubit/inventory_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/cubit/inventory_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/model/stocks_availability_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/screens/stocks_availability/widgets/availability_item_card.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:groute_nartec/presentation/widgets/shimmer_placeholder.dart';

class StocksAvailabilityScreen extends StatefulWidget {
  const StocksAvailabilityScreen({super.key});

  @override
  State<StocksAvailabilityScreen> createState() =>
      _StocksAvailabilityScreenState();
}

class _StocksAvailabilityScreenState extends State<StocksAvailabilityScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<StocksAvailablityModel> _filteredStocks = [];
  List<StocksAvailablityModel> _allStocks = [];

  @override
  void initState() {
    super.initState();
    context.read<InventoryCubit>().getStocksAvailability();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterStocks(_searchController.text);
  }

  void _filterStocks(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStocks = List.from(_allStocks);
      } else {
        _filteredStocks =
            _allStocks.where((stock) {
              final purchaseOrderNumber =
                  stock.purchaseOrderNumber?.toLowerCase() ?? '';
              final refNo = stock.refNo?.toLowerCase() ?? '';
              final productName =
                  stock.salesInvoiceDetails?.productName?.toLowerCase() ?? '';
              final productDescription =
                  stock.salesInvoiceDetails?.productDescription
                      ?.toLowerCase() ??
                  '';
              final searchQuery = query.toLowerCase();

              return purchaseOrderNumber.contains(searchQuery) ||
                  refNo.contains(searchQuery) ||
                  productName.contains(searchQuery) ||
                  productDescription.contains(searchQuery);
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Stocks Availability',
      actions: [
        IconButton(
          onPressed:
              () => context.read<InventoryCubit>().getStocksAvailability(),
          icon: Icon(Icons.refresh, color: AppColors.primaryBlue),
        ),
      ],
      body: Column(
        children: [
          // Content
          Expanded(
            child: BlocConsumer<InventoryCubit, InventoryState>(
              listener: (context, state) {
                if (state is StocksAvailabilityLoaded) {
                  setState(() {
                    _allStocks = state.stocks;
                    _filterStocks(_searchController.text);
                  });
                }
              },
              builder: (context, state) {
                if (state is StocksAvailabilityLoading) {
                  return _buildLoadingState();
                } else if (state is StocksAvailabilityError) {
                  return _buildErrorState(state.error);
                } else if (state is StocksAvailabilityLoaded) {
                  return _buildSuccessState();
                }
                return _buildLoadingState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Summary cards placeholders
          Row(
            children: [
              Expanded(child: _buildSummaryCardPlaceholder()),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCardPlaceholder()),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCardPlaceholder()),
            ],
          ),
          const SizedBox(height: 20),

          // Stock items placeholders
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildAvailabilityItemPlaceholder(),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCardPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerPlaceholder(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ShimmerPlaceholder(
            child: Container(
              height: 24,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ShimmerPlaceholder(
            child: Container(
              height: 14,
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityItemPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              ShimmerPlaceholder(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder(
                      child: Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ShimmerPlaceholder(
                      child: Container(
                        height: 14,
                        width: 150,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ShimmerPlaceholder(
                child: Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Details row
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < 2 ? 8 : 0),
                  child: ShimmerPlaceholder(
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.triangleExclamation,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to Load Availability',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textMedium),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed:
                  () => context.read<InventoryCubit>().getStocksAvailability(),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    if (_filteredStocks.isEmpty && _searchController.text.isNotEmpty) {
      return _buildNoSearchResults();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(),
          const SizedBox(height: 20),

          // Results Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_filteredStocks.length} Orders Found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Availability Items List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStocks.length,
              itemBuilder: (context, index) {
                final stock = _filteredStocks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AvailabilityItemCard(stock: stock),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final totalOrders = _allStocks.length;
    final totalStocks = _allStocks.fold<int>(
      0,
      (sum, stock) => sum + (stock.totalStocks ?? 0),
    );
    final ordersWithStocks =
        _allStocks.where((stock) => (stock.totalStocks ?? 0) > 0).length;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Orders',
            totalOrders.toString(),
            FontAwesomeIcons.clipboardList,
            AppColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Total Stocks',
            totalStocks.toString(),
            FontAwesomeIcons.cubes,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'With Stock',
            ordersWithStocks.toString(),
            FontAwesomeIcons.check,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.magnifyingGlass,
                size: 40,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Results Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No stocks match your search "${_searchController.text}".\nTry different keywords.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textMedium),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                _searchController.clear();
                _filterStocks('');
              },
              child: Text(
                'Clear Search',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
