import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';

class ScannedItemCard extends StatelessWidget {
  final Map<dynamic, dynamic>? itemData;
  final VoidCallback? onDelete;

  const ScannedItemCard({Key? key, required this.itemData, this.onDelete})
    : super(key: key);

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
          color: isDark ? AppColors.grey800 : AppColors.grey200,
          width: 1,
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
              // Optional onTap functionality
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
                // Header with SSCC number and delete button
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
                      Row(
                        children: [
                          Icon(
                            Icons.qr_code_rounded,
                            color:
                                isDark
                                    ? AppColors.primaryLight
                                    : AppColors.primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SSCC: ${itemData?["ssccNo"] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color:
                                  isDark
                                      ? AppColors.primaryLight
                                      : AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      if (onDelete != null)
                        IconButton(
                          onPressed: onDelete,
                          icon: Icon(
                            Icons.close_rounded,
                            color:
                                isDark
                                    ? AppColors.error.withValues(alpha: 0.9)
                                    : AppColors.error,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 20,
                        ),
                    ],
                  ),
                ),

                // Main content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description and Serial
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left column - Description
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textMedium,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  itemData?["description"] ?? 'No description',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textLight,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Right column - Serial No
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Serial No',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textMedium,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.pin_rounded,
                                      size: 14,
                                      color:
                                          isDark
                                              ? AppColors.secondaryLight
                                              : AppColors.secondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        itemData?["serialNo"] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              isDark
                                                  ? AppColors.secondaryLight
                                                  : AppColors.secondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // GTIN and Member ID
                      Row(
                        children: [
                          // GTIN
                          Expanded(
                            child: _buildInfoRow(
                              'GTIN',
                              itemData?["serialGTIN"] ?? 'N/A',
                              Icons.barcode_reader,
                              isDark,
                              textLight,
                              textMedium,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Member ID
                          Expanded(
                            child: _buildInfoRow(
                              'Member ID',
                              itemData?["memberId"]?.toString() ?? 'N/A',
                              Icons.person_outline_rounded,
                              isDark,
                              textLight,
                              textMedium,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Bin Location and Master Packaging ID
                      Row(
                        children: [
                          // Bin Location
                          Expanded(
                            child: _buildInfoRow(
                              'Bin Location',
                              itemData?["binLocationId"]?.toString() ?? 'N/A',
                              Icons.location_on_outlined,
                              isDark,
                              textLight,
                              textMedium,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Master Packaging ID
                          Expanded(
                            child: _buildInfoRow(
                              'Package ID',
                              itemData?["masterPackagingId"]?.toString() ??
                                  'N/A',
                              Icons.inventory_2_outlined,
                              isDark,
                              textLight,
                              textMedium,
                            ),
                          ),
                        ],
                      ),
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
