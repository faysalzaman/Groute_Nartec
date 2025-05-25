import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/product_on_pallet.dart';
import 'package:intl/intl.dart';

class ProductOnPalletCard extends StatelessWidget {
  final ProductOnPallet item;
  final bool isSelected;
  final Function(bool?) onSelectionChanged;

  const ProductOnPalletCard({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textLight = isDark ? AppColors.textLight : AppColors.textDark;
    final textMedium =
        isDark
            ? AppColors.textLight.withValues(alpha: 0.7)
            : AppColors.textMedium;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            isDark
                ? AppColors.grey900.withValues(alpha: 0.95)
                : AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isSelected
                  ? (isDark ? AppColors.primaryLight : AppColors.primaryBlue)
                  : (isDark ? AppColors.grey800 : AppColors.grey200),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onSelectionChanged(!isSelected);
            },
            splashColor:
                isDark
                    ? AppColors.primaryDark.withValues(alpha: 0.1)
                    : AppColors.primaryLight.withValues(alpha: 0.1),
            highlightColor:
                isDark
                    ? AppColors.primaryDark.withValues(alpha: 0.05)
                    : AppColors.primaryLight.withValues(alpha: 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with name and checkbox
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? AppColors.primaryDark.withValues(alpha: 0.2)
                            : AppColors.primaryLight.withValues(alpha: 0.1),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? AppColors.grey800 : AppColors.grey200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color:
                                  isDark
                                      ? AppColors.primaryLight
                                      : AppColors.primaryBlue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.name ?? 'Unknown Product',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isDark
                                          ? AppColors.primaryLight
                                          : AppColors.primaryBlue,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: isSelected,
                        onChanged: onSelectionChanged,
                        activeColor:
                            isDark
                                ? AppColors.primaryLight
                                : AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),

                // Card content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Serial Number and Pallet ID
                      Row(
                        children: [
                          // Serial Number
                          Expanded(
                            child: _buildInfoRow(
                              'Serial Number',
                              item.serialNumber ?? 'N/A',
                              Icons.qr_code_scanner,
                              isDark,
                              textLight,
                              textMedium,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Pallet ID
                          Expanded(
                            child: _buildInfoRow(
                              'Pallet ID',
                              item.palletId ?? 'N/A',
                              Icons.palette,
                              isDark,
                              textLight,
                              textMedium,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // GTIN
                      _buildInfoRow(
                        'GTIN',
                        item.gtin ?? 'N/A',
                        Icons.barcode_reader,
                        isDark,
                        textLight,
                        textMedium,
                      ),

                      const SizedBox(height: 12),

                      // Manufacturing Date and Expiry Date
                      Row(
                        children: [
                          // Manufacturing Date
                          Expanded(
                            child: _buildInfoRow(
                              'Manufacturing Date',
                              _formatDate(item.manufectureDate),
                              Icons.calendar_today,
                              isDark,
                              textLight,
                              textMedium,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Expiry Date
                          Expanded(
                            child: _buildInfoRow(
                              'Expiry Date',
                              _formatDate(item.expiryDate),
                              Icons.event_busy,
                              isDark,
                              textLight,
                              textMedium,
                            ),
                          ),
                        ],
                      ),

                      // Additional product info if needed
                      if (item.quantity != null) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Quantity',
                          '${item.quantity}',
                          Icons.inventory,
                          isDark,
                          textLight,
                          textMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'N/A';
    }

    try {
      // Parse the date - adjust the format based on your actual date format
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString; // Return the original string if parsing fails
    }
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    bool isDark,
    Color textColor,
    Color labelColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: labelColor)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 14, color: textColor.withValues(alpha: 0.7)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 13, color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
