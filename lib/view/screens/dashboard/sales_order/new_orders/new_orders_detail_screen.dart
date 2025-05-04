import 'package:flutter/material.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/view/widgets/custom_scaffold.dart';
import 'package:intl/intl.dart';

class NewOrdersDetailScreen extends StatelessWidget {
  final SalesOrderModel salesOrder;

  const NewOrdersDetailScreen({super.key, required this.salesOrder});

  // Helper function to format date strings
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateString);
      // Consider locale if needed: DateFormat('MMM dd, yyyy hh:mm a', Localizations.localeOf(context).toString())
      return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      // Log error: print('Date parsing error: $e');
      return dateString; // Return original string if parsing fails
    }
  }

  // Helper function to format currency
  String _formatCurrency(String? amount) {
    if (amount == null || amount.isEmpty) return 'N/A';
    try {
      final number = double.parse(amount);
      // Use NumberFormat for better currency formatting (add dependency 'intl' if not already present)
      // Adjust locale and symbol as needed
      final format = NumberFormat.currency(locale: 'en_SA', symbol: 'SAR ');
      return format.format(number);
    } catch (e) {
      // Log error: print('Currency parsing error: $e');
      return 'SAR $amount'; // Fallback
    }
  }

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
            _buildSectionCard(
              context: context,
              title: 'Order Summary',
              icon: Icons.receipt_long, // Added icon
              children: [
                _buildDetailRow(
                  context,
                  'Order Number:',
                  salesOrder.salesInvoiceNumber,
                  icon: Icons.tag,
                ),
                _buildDetailRow(
                  context,
                  'PO Number:',
                  salesOrder.purchaseOrderNumber,
                  icon: Icons.confirmation_number,
                ),
                _buildDetailRow(
                  context,
                  'Order Date:',
                  _formatDate(salesOrder.orderDate),
                  icon: Icons.calendar_today,
                ),
                _buildDetailRow(
                  context,
                  'Delivery Date:',
                  _formatDate(salesOrder.deliveryDate),
                  icon: Icons.local_shipping,
                ),
                _buildDetailRow(
                  context,
                  'Status:',
                  salesOrder.status?.toUpperCase(),
                  icon: Icons.info_outline,
                ),
                _buildDetailRow(
                  context,
                  'Total Amount:',
                  _formatCurrency(salesOrder.totalAmount),
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
              _buildSectionCard(
                context: context,
                title: 'Customer Information',
                icon: Icons.person_pin_circle, // Added icon
                children: [
                  _buildDetailRow(
                    context,
                    'Name:',
                    customer.companyNameEnglish,
                    icon: Icons.business,
                  ),
                  _buildDetailRow(
                    context,
                    'Contact:',
                    customer.contactPerson,
                    icon: Icons.person,
                  ),
                  _buildDetailRow(
                    context,
                    'Email:',
                    customer.email,
                    icon: Icons.email,
                  ),
                  _buildDetailRow(
                    context,
                    'Mobile:',
                    customer.mobileNo,
                    icon: Icons.phone,
                  ),
                  _buildDetailRow(
                    context,
                    'Address:',
                    customer.address,
                    icon: Icons.location_on,
                  ),
                  _buildDetailRow(
                    context,
                    'GLN:',
                    customer.gln,
                    icon: Icons.qr_code,
                  ), // Example icon
                ],
              ),
            const SizedBox(height: 16),

            // Items Card
            _buildSectionCard(
              context: context,
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
                      : items
                          .map((item) => _buildItemTile(context, item))
                          .toList(),
            ),
            const SizedBox(height: 16),

            // Timestamps Card (Optional) - Consider making this expandable if often long
            _buildSectionCard(
              context: context,
              title: 'Timestamps',
              icon: Icons.timeline, // Added icon
              children: [
                _buildDetailRow(
                  context,
                  'Assigned:',
                  _formatDate(salesOrder.assignedTime),
                  icon: Icons.assignment_ind,
                ),
                _buildDetailRow(
                  context,
                  'Journey Started:',
                  _formatDate(salesOrder.startJourneyTime),
                  icon: Icons.play_arrow,
                ),
                _buildDetailRow(
                  context,
                  'Arrived:',
                  _formatDate(salesOrder.arrivalTime),
                  icon: Icons.flag,
                ),
                _buildDetailRow(
                  context,
                  'Unloading:',
                  _formatDate(salesOrder.unloadingTime),
                  icon: Icons.downloading,
                ),
                _buildDetailRow(
                  context,
                  'Invoice Created:',
                  _formatDate(salesOrder.invoiceCreationTime),
                  icon: Icons.receipt,
                ),
                _buildDetailRow(
                  context,
                  'Journey Ended:',
                  _formatDate(salesOrder.endJourneyTime),
                  icon: Icons.stop,
                ),
                _buildDetailRow(
                  context,
                  'Picked:',
                  _formatDate(salesOrder.pickDate),
                  icon: Icons.inventory,
                ),
                _buildDetailRow(
                  context,
                  'Created At:',
                  _formatDate(salesOrder.createdAt),
                  icon: Icons.add_circle_outline,
                ),
                _buildDetailRow(
                  context,
                  'Updated At:',
                  _formatDate(salesOrder.updatedAt),
                  icon: Icons.edit_note,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Other Details Card (Optional)
            _buildSectionCard(
              context: context,
              title: 'Other Details',
              icon: Icons.more_horiz, // Added icon
              children: [
                _buildDetailRow(
                  context,
                  'Sub User ID:',
                  salesOrder.subUserId,
                  icon: Icons.person_outline,
                ),
                _buildDetailRow(
                  context,
                  'Driver ID:',
                  salesOrder.driverId,
                  icon: Icons.drive_eta,
                ),
                _buildDetailRow(
                  context,
                  'Member ID:',
                  salesOrder.memberId,
                  icon: Icons.badge,
                ),
                _buildDetailRow(
                  context,
                  'Signature:',
                  salesOrder.signature != null ? 'Provided' : 'Not Provided',
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

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    IconData? icon, // Added icon parameter
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 5, // Slightly increased elevation
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ), // Horizontal margin for cards
      color: Colors.white, // Use surface color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Clip content to rounded corners
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // Use Row for title and icon
              children: [
                if (icon != null) ...[
                  Icon(icon, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary, // Use primary color
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1), // Increased spacing
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String? value, {
    IconData? icon, // Added icon parameter
    TextStyle? valueStyle, // Optional style for value
  }) {
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
            child: Text(effectiveValue!, style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, SalesInvoiceDetails item) {
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
              _buildItemDetailText(
                context,
                'Qty: ${item.quantity ?? 'N/A'} ${item.unitOfMeasure ?? ''}',
              ),
              _buildItemDetailText(
                context,
                'Price: ${_formatCurrency(item.price)}',
                isBold: true,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItemDetailText(
                context,
                'Qty Picked: ${item.quantityPicked ?? 'N/A'}',
              ),
              _buildItemDetailText(
                context,
                'Total: ${_formatCurrency(item.totalPrice)}',
                isBold: true,
              ),
            ],
          ),
          const Divider(height: 20, thickness: 0.5), // Thinner divider
        ],
      ),
    );
  }

  // Helper for consistent item detail text styling
  Widget _buildItemDetailText(
    BuildContext context,
    String text, {
    bool isBold = false,
  }) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
