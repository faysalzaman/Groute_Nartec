import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final IconData? icon;
  final TextStyle? valueStyle;

  const DetailRow({
    Key? key,
    required this.label,
    required this.value,
    this.icon,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveValue = value?.isNotEmpty == true ? value : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
      ), // Adjusted vertical padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130, // Adjusted width
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ), // Use theme color
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8), // Spacing between label and value
          Expanded(
            child: Text(
              effectiveValue!,
              style: valueStyle ?? TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
