import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:groute_nartec/core/extensions/string_extensions.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/widgets/item_detail_text.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/loading/loading_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/screens/loading/gs1_product_details_screen.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';

class ItemTile extends StatelessWidget {
  final SalesInvoiceDetails item;

  const ItemTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.productDescription ?? 'Unknown Product',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary, // Use primary color
                  ),
                ),
              ),
              Column(
                children: [
                  BarcodeWidget(
                    data: item.productId ?? "",
                    barcode: Barcode.qrCode(),
                    width: 100,
                    height: 50,
                  ),
                  Text(
                    '${item.productId}',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
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
                    'Qty: ${item.quantity ?? '0'} ${item.unitOfMeasure ?? ''}',
              ),
              ItemDetailText(
                text: 'Price: ${item.price?.formattedCurrency ?? '0'}',
                isBold: true,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ItemDetailText(text: 'Qty Picked: ${item.quantityPicked ?? '0'}'),
              ItemDetailText(
                text: 'Total: ${item.totalPrice?.formattedCurrency ?? '0'}',
                isBold: true,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Start Picking Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomElevatedButton(
                title: "Start Picking",
                onPressed: () {
                  LoadingCubit.get(context).setSalesInvoiceDetails(item);
                  // Navigate to GS1 product details screen
                  AppNavigator.push(
                    context,
                    GS1ProductDetailsScreen(barcode: item.productId ?? ''),
                  );
                },
                height: 25,
                width: 120,
              ),
            ],
          ),

          const Divider(height: 20, thickness: 0.5), // Thinner divider
        ],
      ),
    );
  }
}
