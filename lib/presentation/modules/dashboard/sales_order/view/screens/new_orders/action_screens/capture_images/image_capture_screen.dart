// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/view/screens/new_orders/action_screen.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:image_picker/image_picker.dart';

class ImageCaptureScreen extends StatefulWidget {
  const ImageCaptureScreen({
    super.key,
    required this.salesOrderLocation,
    required this.currentDeviceLocation,
    required this.salesOrder,
  });

  final LatLng salesOrderLocation;
  final LatLng currentDeviceLocation;
  final SalesOrderModel salesOrder;

  @override
  State<ImageCaptureScreen> createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  static const int _maxImages = 5;
  static const double _previewHeight = 280.0;
  static const double _galleryHeight = 100.0;
  static const double _thumbnailSize = 70.0;

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesCubit, SalesState>(
      listener: (context, state) async {
        if (state is SalesOrderUploadImageSuccess) {
          // Mark the process as completed
          await AppPreferences.setCaptureImagesCompleted(
            widget.salesOrder.id ?? '',
          );
          Navigator.pop(context);
          AppNavigator.pushReplacement(
            context,
            ActionScreen(
              salesOrderLocation: widget.salesOrderLocation,
              currentDeviceLocation: widget.currentDeviceLocation,
              salesOrder: widget.salesOrder,
            ),
          );
          AppSnackbars.success(context, "Images uploaded successfully.");
        }
        if (state is SalesOrderUploadImageError) {
          AppSnackbars.danger(
            context,
            state.error.replaceAll("Exception: ", ""),
          );
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          title: "Capture Images",
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview Section
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      const Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Container(
                    height: _previewHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          _images.isNotEmpty
                              ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    File(_images.last.path),
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Latest Image',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 48,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No images captured yet',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap "Capture Image" to start',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Gallery Section
                  Row(
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Captured Images',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Container(
                    height: _galleryHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child:
                        _images.isEmpty
                            ? Center(
                              child: Text(
                                'No images in gallery',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: _images.length,
                              itemBuilder:
                                  (context, index) => Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.file(
                                            File(_images[index].path),
                                            width: _thumbnailSize,
                                            height: _thumbnailSize,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          right: -4,
                                          top: -4,
                                          child: GestureDetector(
                                            onTap: () => _removeImage(index),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 4,
                                          left: 4,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.7,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Column(
                    children: [
                      // Capture Button
                      Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.primaryBlue.withValues(
                            alpha: _images.length < _maxImages ? 1 : 0.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap:
                                _images.length < _maxImages ? _pickImage : null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _images.length < _maxImages
                                        ? 'Capture Image'
                                        : 'Maximum images reached',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Save Button
                      CustomElevatedButton(
                        title: "Upload Images",
                        buttonState:
                            state is SalesOrderUploadImageLoading
                                ? ButtonState.loading
                                : ButtonState.idle,
                        height: 40,
                        onPressed:
                            _images.isNotEmpty
                                ? () async {
                                  await context.read<SalesCubit>().uploadImages(
                                    _images
                                        .map((image) => File(image.path))
                                        .toList(),

                                    widget.salesOrder.id.toString(),
                                  );
                                }
                                : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    if (_images.length < _maxImages) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() => _images.add(image));
      }
    } else {
      AppSnackbars.danger(
        context,
        "You can only add up to $_maxImages images.",
      );
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }
}
