// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart' show AppColors;
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/action_screens/capture_images/image_capture_screen.dart';

class DisplayProductScreen extends StatefulWidget {
  const DisplayProductScreen({
    super.key,
    required this.salesOrderLocation,
    required this.currentDeviceLocation,
    required this.salesOrder,
  });

  final LatLng salesOrderLocation;
  final LatLng currentDeviceLocation;
  final SalesOrderModel salesOrder;

  @override
  State<DisplayProductScreen> createState() => _DisplayProductScreenState();
}

class _DisplayProductScreenState extends State<DisplayProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Picklist Details'), elevation: 2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: AppColors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.camera_alt, size: 40, color: Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        widget.salesOrder.salesInvoiceDetails?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item =
                          widget.salesOrder.salesInvoiceDetails![index];
                      return GestureDetector(
                        onTap: () {
                          AppNavigator.push(
                            context,
                            ImageCaptureScreen(
                              salesOrderLocation: widget.salesOrderLocation,
                              currentDeviceLocation:
                                  widget.currentDeviceLocation,
                              salesOrder: widget.salesOrder,
                              index: index,
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          color: AppColors.white,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              item.id ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(
                                  'Sales Invoice Number',
                                  item.salesInvoiceId ?? 'N/A',
                                ),
                                _buildInfoRow(
                                  'Product Name',
                                  item.productName ?? 'N/A',
                                ),
                                _buildInfoRow(
                                  'Product Description',
                                  item.productDescription ?? 'N/A',
                                ),
                                _buildInfoRow(
                                  'Delivery Time',
                                  item.price ?? 'N/A',
                                ),
                                _buildInfoRow(
                                  'Quantity',
                                  item.quantity?.toString() ?? '0',
                                ),
                                _buildInfoRow(
                                  'QTY Picked',
                                  item.quantityPicked ?? '0',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
