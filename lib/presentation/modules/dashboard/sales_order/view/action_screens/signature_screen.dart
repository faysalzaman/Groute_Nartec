// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart' as path_provider;

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({
    super.key,
    required this.salesOrderLocation,
    required this.currentDeviceLocation,
    required this.salesOrder,
  });

  final LatLng salesOrderLocation;
  final LatLng currentDeviceLocation; // Add this parameter
  final SalesOrderModel salesOrder;

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  File? imageFile;
  bool _permissionChecked = false;

  @override
  void initState() {
    super.initState();
    // Request storage permission when the screen is initialized
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    final hasPermission = await _requestStoragePermission();
    setState(() {
      _permissionChecked = true;
    });

    if (!hasPermission) {
      // Show a message if permission was denied
      Future.delayed(Duration.zero, () {
        AppSnackbars.warning(
          context,
          'Storage permission is required to save the signature',
        );
      });
    }
  }

  Future<void> saveSignature() async {
    // If we haven't checked permissions yet, check them now
    if (!_permissionChecked) {
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        AppSnackbars.danger(
          context,
          'Storage permission is required to save the signature',
        );
        return;
      }
    }

    final signatureData = await _signaturePadKey.currentState!.toImage();
    final bytes = await signatureData.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (bytes != null) {
      final buffer = bytes.buffer.asUint8List();

      try {
        final directory =
            await path_provider.getApplicationDocumentsDirectory();
        final path = '${directory.path}/signature.png';
        imageFile = File(path);
        await imageFile!.writeAsBytes(buffer);

        // If we have a saved image, upload it
        if (imageFile != null) {
          context.read<SalesCubit>().uploadSignature(
            widget.salesOrder.id.toString(),
            imageFile!,
          );
        }
      } catch (e) {
        AppSnackbars.danger(
          context,
          'Failed to save signature: ${e.toString()}',
        );
      }
    }
  }

  Future<bool> _requestStoragePermission() async {
    // For Android, we need different permissions depending on SDK version
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }
      return false;
    }
    // For iOS, we generally don't need explicit permission for app document directory
    else if (Platform.isIOS) {
      return true;
    }

    // For other platforms, default to checking storage permission
    return await Permission.storage.request().isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesCubit, SalesState>(
      listener: (context, state) {
        if (state is SalesOrderAddSignatureSuccessState) {
          Navigator.pop(context);
          AppSnackbars.success(context, "Signature uploaded successfully");
        }
        if (state is SalesOrderAddSignatureErrorState) {
          AppSnackbars.danger(
            context,
            state.error.replaceAll("Exception: ", ""),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50], // Subtle background color
          appBar: AppBar(
            backgroundColor: AppColors.primaryBlue,
            elevation: 0, // Remove shadow
            title: const Text("Receiver Signature"),
            centerTitle: true,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Please sign below',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SfSignaturePad(
                        key: _signaturePadKey,
                        backgroundColor: Colors.white,
                        strokeColor: Colors.black,
                        minimumStrokeWidth: 1.0,
                        maximumStrokeWidth: 4.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              () => _signaturePadKey.currentState?.clear(),
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.black54,
                          ),
                          label: const Text('Clear'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: Colors.black54,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: CustomElevatedButton(
                          title: "Save Signature",
                          height: 40,
                          onPressed: saveSignature,
                          buttonState:
                              state is SalesOrderAddSignatureLoadingState
                                  ? ButtonState.loading
                                  : ButtonState.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
