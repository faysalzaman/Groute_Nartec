import 'package:flutter/material.dart';
import 'package:groute_nartec/core/extensions/string_extensions.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/widgets/detail_row.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/widgets/item_tile.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/widgets/section_card.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';

class NewOrdersDetailScreen extends StatelessWidget {
  final SalesOrderModel salesOrder;

  const NewOrdersDetailScreen({super.key, required this.salesOrder});

  @override
  Widget build(BuildContext context) {
    final customer = salesOrder.customer;
    final items = salesOrder.salesInvoiceDetails ?? [];
    final theme = Theme.of(context); // Get theme data

    return CustomScaffold(
      title: 'Order #${salesOrder.salesInvoiceNumber ?? 'Details'}',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10.0), // Adjusted padding
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Stretch cards horizontally
          children: [
            // Order Summary Card
            SectionCard(
              title: 'Order Summary',
              icon: Icons.receipt_long, // Added icon
              children: [
                DetailRow(
                  label: 'Order Number:',
                  value: salesOrder.salesInvoiceNumber,
                  icon: Icons.tag,
                ),
                DetailRow(
                  label: 'PO Number:',
                  value: salesOrder.purchaseOrderNumber,
                  icon: Icons.confirmation_number,
                ),
                DetailRow(
                  label: 'Order Date:',
                  value: salesOrder.orderDate?.formattedDate ?? 'N/A',
                  icon: Icons.calendar_today,
                ),
                DetailRow(
                  label: 'Delivery Date:',
                  value: salesOrder.deliveryDate?.formattedDate ?? 'N/A',
                  icon: Icons.local_shipping,
                ),
                DetailRow(
                  label: 'Status:',
                  value: salesOrder.status?.toUpperCase(),
                  icon: Icons.info_outline,
                ),
                DetailRow(
                  label: 'Total Amount:',
                  value: salesOrder.totalAmount?.formattedCurrency ?? 'N/A',
                  icon: Icons.attach_money,
                  valueStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ), // Highlight total
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Customer Information Card
            if (customer != null)
              SectionCard(
                title: 'Customer Information',
                icon: Icons.person_pin_circle, // Added icon
                children: [
                  DetailRow(
                    label: 'Name:',
                    value: customer.companyNameEnglish,
                    icon: Icons.business,
                  ),
                  DetailRow(
                    label: 'Contact:',
                    value: customer.contactPerson,
                    icon: Icons.person,
                  ),
                  DetailRow(
                    label: 'Email:',
                    value: customer.email,
                    icon: Icons.email,
                  ),
                  DetailRow(
                    label: 'Mobile:',
                    value: customer.mobileNo,
                    icon: Icons.phone,
                  ),
                  DetailRow(
                    label: 'Address:',
                    value: customer.address,
                    icon: Icons.location_on,
                  ),
                  DetailRow(
                    label: 'GLN:',
                    value: customer.gln,
                    icon: Icons.qr_code,
                  ), // Example icon
                ],
              ),
            const SizedBox(height: 16),

            // Items Card
            SectionCard(
              title: 'Items (${items.length})',
              icon: Icons.inventory_2, // Added icon
              children:
                  items.isEmpty
                      ? [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text(
                              'No items found.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ),
                        ),
                      ]
                      : items.map((item) => ItemTile(item: item)).toList(),
            ),
            const SizedBox(height: 16),

            // Timestamps Card (Optional) - Consider making this expandable if often long
            SectionCard(
              title: 'Timestamps',
              icon: Icons.timeline, // Added icon
              children: [
                DetailRow(
                  label: 'Assigned:',
                  value: salesOrder.assignedTime?.formattedDate ?? 'N/A',
                  icon: Icons.assignment_ind,
                ),
                DetailRow(
                  label: 'Journey Started:',
                  value: salesOrder.startJourneyTime?.formattedDate ?? 'N/A',
                  icon: Icons.play_arrow,
                ),
                DetailRow(
                  label: 'Arrived:',
                  value: salesOrder.arrivalTime?.formattedDate ?? 'N/A',
                  icon: Icons.flag,
                ),
                DetailRow(
                  label: 'Unloading:',
                  value: salesOrder.unloadingTime?.formattedDate ?? 'N/A',
                  icon: Icons.downloading,
                ),
                DetailRow(
                  label: 'Invoice Created:',
                  value: salesOrder.invoiceCreationTime?.formattedDate ?? 'N/A',
                  icon: Icons.receipt,
                ),
                DetailRow(
                  label: 'Journey Ended:',
                  value: salesOrder.endJourneyTime?.formattedDate ?? 'N/A',
                  icon: Icons.stop,
                ),
                DetailRow(
                  label: 'Picked:',
                  value: salesOrder.pickDate?.formattedDate ?? 'N/A',
                  icon: Icons.inventory,
                ),
                DetailRow(
                  label: 'Created At:',
                  value: salesOrder.createdAt?.formattedDate ?? 'N/A',
                  icon: Icons.add_circle_outline,
                ),
                DetailRow(
                  label: 'Updated At:',
                  value: salesOrder.updatedAt?.formattedDate ?? 'N/A',
                  icon: Icons.edit_note,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Other Details Card (Optional)
            SectionCard(
              title: 'Other Details',
              icon: Icons.more_horiz, // Added icon
              children: [
                DetailRow(
                  label: 'Sub User ID:',
                  value: salesOrder.subUserId,
                  icon: Icons.person_outline,
                ),
                DetailRow(
                  label: 'Driver ID:',
                  value: salesOrder.driverId,
                  icon: Icons.drive_eta,
                ),
                DetailRow(
                  label: 'Member ID:',
                  value: salesOrder.memberId,
                  icon: Icons.badge,
                ),
                DetailRow(
                  label: 'Signature:',
                  value:
                      salesOrder.signature != null
                          ? 'Provided'
                          : 'Not Provided',
                  icon: Icons.edit, // Or Icons.image if it's a URL
                ),
              ],
            ),
            const SizedBox(height: 24), // Add some bottom padding
          ],
        ),
      ),
    );
  }

  // Helper for consistent item detail text styling
}
