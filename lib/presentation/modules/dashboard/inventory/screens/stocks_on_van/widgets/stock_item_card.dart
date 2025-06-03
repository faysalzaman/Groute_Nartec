import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/model/stocks_on_van_model.dart';

class StockItemCard extends StatelessWidget {
  final StocksOnVanModel stock;

  const StockItemCard({super.key, required this.stock});

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
                    // Item Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        FontAwesomeIcons.box,
                        color: AppColors.primaryBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Item Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stock.itemDescription ?? 'Unknown Item',
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
                            'Code: ${stock.itemCode ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quantity Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getQuantityColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${stock.availableQty ?? 0}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getQuantityColor(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Details Row
                Row(
                  children: [
                    // Price
                    Expanded(
                      child: _buildDetailItem(
                        FontAwesomeIcons.dollarSign,
                        'Price',
                        '${stock.itemPrice ?? 0}',
                        Colors.green,
                      ),
                    ),

                    // Unit
                    Expanded(
                      child: _buildDetailItem(
                        FontAwesomeIcons.cube,
                        'Unit',
                        stock.itemUnit ?? 'N/A',
                        Colors.blue,
                      ),
                    ),

                    // Batch
                    Expanded(
                      child: _buildDetailItem(
                        FontAwesomeIcons.tag,
                        'Batch',
                        stock.batch ?? 'N/A',
                        Colors.purple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Status Row
                Row(
                  children: [
                    // Location
                    if (stock.binNoLocation != null) ...[
                      Icon(
                        FontAwesomeIcons.locationDot,
                        size: 12,
                        color: AppColors.textMedium,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        stock.binNoLocation!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],

                    // Expiry Date
                    if (stock.expiryDate != null) ...[
                      Icon(
                        FontAwesomeIcons.calendar,
                        size: 12,
                        color: _getExpiryColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(stock.expiryDate!),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getExpiryColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                    ],

                    // Status Badge
                    if (stock.status != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          stock.status!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(),
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

  Color _getQuantityColor() {
    final qty = stock.availableQty ?? 0;
    if (qty == 0) return Colors.red;
    if (qty < 10) return Colors.orange;
    return Colors.green;
  }

  Color _getExpiryColor() {
    if (stock.expiryDate == null) return AppColors.textMedium;

    final expiryDate = DateTime.parse(stock.expiryDate!);
    final now = DateTime.now();
    final daysUntilExpiry = expiryDate.difference(now).inDays;

    if (daysUntilExpiry < 0) return Colors.red;
    if (daysUntilExpiry < 30) return Colors.orange;
    return Colors.green;
  }

  Color _getStatusColor() {
    switch (stock.status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return AppColors.textMedium;
    }
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
                              FontAwesomeIcons.box,
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
                                  stock.itemDescription ?? 'Unknown Item',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Code: ${stock.itemCode ?? 'N/A'}',
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
                            _buildDetailSection('Inventory Information', [
                              _DetailItem(
                                'Available Quantity',
                                '${stock.availableQty ?? 0} ${stock.itemUnit ?? ''}',
                              ),
                              _DetailItem('Price', '${stock.itemPrice ?? 0}'),
                              _DetailItem('Batch', stock.batch ?? 'N/A'),
                              _DetailItem(
                                'Location',
                                stock.binNoLocation ?? 'N/A',
                              ),
                            ]),

                            const SizedBox(height: 20),

                            _buildDetailSection('Product Information', [
                              _DetailItem(
                                'Serial Number',
                                stock.serialNumber ?? 'N/A',
                              ),
                              _DetailItem('Pallet ID', stock.palletId ?? 'N/A'),
                              _DetailItem('GLN', stock.gln ?? 'N/A'),
                              _DetailItem(
                                'Menu Number',
                                stock.menuNumber ?? 'N/A',
                              ),
                            ]),

                            const SizedBox(height: 20),

                            _buildDetailSection('Dates', [
                              _DetailItem(
                                'Expiry Date',
                                stock.expiryDate != null
                                    ? _formatDate(stock.expiryDate!)
                                    : 'N/A',
                              ),
                              _DetailItem(
                                'Manufacture Date',
                                stock.manufectureDate != null
                                    ? _formatDate(stock.manufectureDate!)
                                    : 'N/A',
                              ),
                              _DetailItem(
                                'Created At',
                                stock.createdAt != null
                                    ? _formatDate(stock.createdAt!)
                                    : 'N/A',
                              ),
                              _DetailItem(
                                'Updated At',
                                stock.updatedAt != null
                                    ? _formatDate(stock.updatedAt!)
                                    : 'N/A',
                              ),
                            ]),

                            if (stock.vehicle != null) ...[
                              const SizedBox(height: 20),
                              _buildDetailSection('Vehicle Information', [
                                _DetailItem(
                                  'Vehicle Name',
                                  stock.vehicle!.name ?? 'N/A',
                                ),
                                _DetailItem(
                                  'Plate Number',
                                  stock.vehicle!.plateNumber ?? 'N/A',
                                ),
                                _DetailItem(
                                  'Description',
                                  stock.vehicle!.description ?? 'N/A',
                                ),
                              ]),
                            ],

                            const SizedBox(height: 20),

                            _buildDetailSection('Status Information', [
                              _DetailItem('Status', stock.status ?? 'N/A'),
                              _DetailItem(
                                'Request Status',
                                stock.requestStatus ?? 'N/A',
                              ),
                              _DetailItem(
                                'Request Status Code',
                                stock.requestStatusCode ?? 'N/A',
                              ),
                            ]),
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
