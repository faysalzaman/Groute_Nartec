import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/model/stocks_availability_model.dart';

class AvailabilityItemCard extends StatelessWidget {
  final StocksAvailablityModel stock;

  const AvailabilityItemCard({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showStockDetails(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Order Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        FontAwesomeIcons.clipboardList,
                        color: AppColors.primaryBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Order Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stock.salesInvoiceDetails?.productDescription ??
                                'Description not available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PO: ${stock.purchaseOrderNumber ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stock Count Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStockCountColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${stock.totalStocks ?? 0}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getStockCountColor(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Details Row
                Row(
                  children: [
                    // Quantity
                    Expanded(
                      child: _buildDetailItem(
                        FontAwesomeIcons.cubes,
                        'Ordered',
                        '${stock.salesInvoiceDetails?.quantity ?? 'N/A'} ${stock.salesInvoiceDetails?.unitOfMeasure ?? ''}',
                        Colors.blue,
                      ),
                    ),

                    // Picked Quantity
                    Expanded(
                      child: _buildDetailItem(
                        FontAwesomeIcons.circleCheck,
                        'Total Stocks',
                        stock.totalStocks.toString(),
                        Colors.green,
                      ),
                    ),

                    // Price
                    Expanded(
                      child: _buildDetailItem(
                        FontAwesomeIcons.dollarSign,
                        'Price',
                        '\$${stock.salesInvoiceDetails?.price ?? '0'}',
                        Colors.purple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Footer Row
                Row(
                  children: [
                    // Ref Number
                    if (stock.refNo != null) ...[
                      Icon(
                        FontAwesomeIcons.hashtag,
                        size: 12,
                        color: AppColors.textMedium,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        stock.refNo!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],

                    // Delivery Date
                    if (stock.salesInvoiceDetails?.deliveryDate != null) ...[
                      Icon(
                        FontAwesomeIcons.calendar,
                        size: 12,
                        color: AppColors.textMedium,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(stock.salesInvoiceDetails!.deliveryDate!),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                      const Spacer(),
                    ],

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getAvailabilityStatusColor().withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getAvailabilityStatus(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getAvailabilityStatusColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 12, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: AppColors.textMedium),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStockCountColor() {
    final count = stock.totalStocks ?? 0;
    if (count == 0) return Colors.red;
    if (count < 5) return Colors.orange;
    return Colors.green;
  }

  Color _getAvailabilityStatusColor() {
    final totalStocks = stock.totalStocks ?? 0;
    if (totalStocks == 0) return Colors.red;
    return Colors.green;
  }

  String _getAvailabilityStatus() {
    final totalStocks = stock.totalStocks ?? 0;
    if (totalStocks == 0) return 'Out of Stock';
    return 'Available';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _showStockDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder:
                (context, scrollController) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.grey300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Header
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              FontAwesomeIcons.clipboardList,
                              color: AppColors.primaryBlue,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stock.salesInvoiceDetails?.productName ??
                                      'Unknown Product',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'PO: ${stock.purchaseOrderNumber ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Details List
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            _buildDetailSection('Order Information', [
                              _DetailItem(
                                'Purchase Order Number',
                                stock.purchaseOrderNumber ?? 'N/A',
                              ),
                              _DetailItem(
                                'Reference Number',
                                stock.refNo ?? 'N/A',
                              ),
                              _DetailItem(
                                'Total Stocks Available',
                                '${stock.totalStocks ?? 0}',
                              ),
                            ]),

                            const SizedBox(height: 20),

                            if (stock.salesInvoiceDetails != null) ...[
                              _buildDetailSection('Product Information', [
                                _DetailItem(
                                  'Product Name',
                                  stock.salesInvoiceDetails!.productName ??
                                      'N/A',
                                ),
                                _DetailItem(
                                  'Description',
                                  stock
                                          .salesInvoiceDetails!
                                          .productDescription ??
                                      'N/A',
                                ),
                                _DetailItem(
                                  'Product ID',
                                  stock.salesInvoiceDetails!.productId ?? 'N/A',
                                ),
                                _DetailItem(
                                  'Unit of Measure',
                                  stock.salesInvoiceDetails!.unitOfMeasure ??
                                      'N/A',
                                ),
                              ]),

                              const SizedBox(height: 20),

                              _buildDetailSection('Quantity Information', [
                                _DetailItem(
                                  'Ordered Quantity',
                                  stock.salesInvoiceDetails!.quantity ?? 'N/A',
                                ),
                                _DetailItem(
                                  'Picked Quantity',
                                  stock.salesInvoiceDetails!.quantityPicked ??
                                      'N/A',
                                ),
                              ]),

                              const SizedBox(height: 20),

                              _buildDetailSection('Pricing Information', [
                                _DetailItem(
                                  'Unit Price',
                                  '\$${stock.salesInvoiceDetails!.price ?? '0'}',
                                ),
                                _DetailItem(
                                  'Total Price',
                                  '\$${stock.salesInvoiceDetails!.totalPrice ?? '0'}',
                                ),
                              ]),

                              const SizedBox(height: 20),

                              _buildDetailSection('Delivery Information', [
                                _DetailItem(
                                  'Delivery Date',
                                  stock.salesInvoiceDetails!.deliveryDate !=
                                          null
                                      ? _formatDate(
                                        stock
                                            .salesInvoiceDetails!
                                            .deliveryDate!,
                                      )
                                      : 'N/A',
                                ),
                                _DetailItem(
                                  'Vehicle ID',
                                  stock.salesInvoiceDetails!.vehicleId ?? 'N/A',
                                ),
                                _DetailItem(
                                  'Sales Invoice ID',
                                  stock.salesInvoiceDetails!.salesInvoiceId ??
                                      'N/A',
                                ),
                              ]),

                              const SizedBox(height: 20),

                              _buildDetailSection('Timestamps', [
                                _DetailItem(
                                  'Created At',
                                  stock.salesInvoiceDetails!.createdAt != null
                                      ? _formatDate(
                                        stock.salesInvoiceDetails!.createdAt!,
                                      )
                                      : 'N/A',
                                ),
                                _DetailItem(
                                  'Updated At',
                                  stock.salesInvoiceDetails!.updatedAt != null
                                      ? _formatDate(
                                        stock.salesInvoiceDetails!.updatedAt!,
                                      )
                                      : 'N/A',
                                ),
                              ]),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildDetailSection(String title, List<_DetailItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children:
                items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border:
                          index < items.length - 1
                              ? Border(
                                bottom: BorderSide(
                                  color: AppColors.grey300,
                                  width: 0.5,
                                ),
                              )
                              : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMedium,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            item.value,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DetailItem {
  final String label;
  final String value;

  _DetailItem(this.label, this.value);
}
