import 'package:flutter/material.dart';
import 'package:groute_nartec/core/extensions/string_extensions.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/widgets/item_detail_text.dart';

class OrderItemTile extends StatelessWidget {
  final SalesInvoiceDetails item;

  const OrderItemTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.productName ?? 'Unknown Product',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary, // Use primary color
            ),
          ),
          if (item.productDescription != null &&
              item.productDescription!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              item.productDescription!,
              style: TextStyle(
                fontSize: 10,
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ItemDetailText(
                text:
                    'Qty: ${item.quantity ?? 'N/A'} ${item.unitOfMeasure ?? ''}',
              ),
              ItemDetailText(
                text: 'Price: ${item.price?.formattedCurrency ?? 'N/A'}',
                isBold: true,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ItemDetailText(
                text: 'Qty Picked: ${item.quantityPicked ?? 'N/A'}',
              ),
              ItemDetailText(
                text: 'Total: ${item.totalPrice?.formattedCurrency ?? 'N/A'}',
                isBold: true,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
