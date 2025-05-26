import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/bin_location_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/container_response_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/pallet_response_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/serial_response_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/sscc_response_model.dart';
import 'package:groute_nartec/repositories/bin_location_repository.dart';
import 'package:groute_nartec/repositories/product_on_pallet_repository.dart';
import 'package:groute_nartec/repositories/vehicle_repository.dart';

import '../../models/loading/product_on_pallet.dart';

part 'loading_states.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingInitial());

  static LoadingCubit get(context) => BlocProvider.of(context);

  final BinLocationRepository _binLocationRepository = BinLocationRepository();
  final VehicleRepository _vehicleRepository = VehicleRepository();
  final HttpService _httpService = HttpService(baseUrl: kGTrackUrl);

  SalesInvoiceDetails? salesInvoiceDetails;
  BinLocationModel? selectedBinLocation;
  bool _byPallet = true;
  bool _bySerial = false;
  int quantityPicked = 0;
  bool isSaveButtonEnabled = false;

  // Lists
  List<BinLocationModel> _binLocations = [];

  // Maps
  final Map<String, List<Map<dynamic, dynamic>>> _scannedItems = {};
  final Map<String, List<ProductOnPallet>> _productOnPallets = {};
  final Map<String, Set<String>> _selectedProductsOnPallet = {};

  // Getters
  List<BinLocationModel> get binLocations => _binLocations;
  bool get byPallet => _byPallet;
  bool get bySerial => _bySerial;
  Map<String, List<Map<dynamic, dynamic>>> get scannedItems => _scannedItems;
  Map<String, List<ProductOnPallet>> get productOnPallets => _productOnPallets;
  Map<String, Set<String>> get selectedItems => _selectedProductsOnPallet;

  /*
  ##############################################################################
  ! Bin Location Methods
  ##############################################################################
  */
  void setSalesInvoiceDetails(SalesInvoiceDetails details) {
    salesInvoiceDetails = details;
  }

  void getSuggestedBinLocations(String productId) async {
    try {
      if (state is BinLocationLoading) return;

      emit(BinLocationLoading());

      _binLocations = await _binLocationRepository.getSuggestedBins(productId);

      emit(BinLocationLoaded());
    } catch (error) {
      emit(BinLocationError(message: error.toString()));
    }
  }

  void setSelectedBinLocation(String binNumber) {
    selectedBinLocation = binLocations.firstWhere(
      (binLocation) => binLocation.binNumber == binNumber.split("-").first,
    );
    emit(BinLocationLoaded());
  }

  /*
  ##############################################################################
  ! Pick Items Methods
  ##############################################################################
  */

  void init() {
    _byPallet = true;
    _bySerial = false;
    _scannedItems.clear();
    _productOnPallets.clear();
    _selectedProductsOnPallet.clear();
    quantityPicked = int.parse(salesInvoiceDetails?.quantityPicked ?? "0");
    isSaveButtonEnabled = false;
    emit(ChangeScanType());
  }

  void setScanType(bool byPallet, bool bySerial) {
    _byPallet = byPallet;
    _bySerial = bySerial;
    print("Scan Type: $_byPallet, $_bySerial");
    emit(ChangeScanType());
  }

  void scanPackagingBySscc({String? palletCode, String? serialNo}) async {
    if (state is ScanItemLoading) {
      return;
    }

    if (palletCode != null) {
      if (palletCode.isEmpty) {
        emit(ScanItemError(message: 'Pallet code is required'));
        return;
      }
    } else if (serialNo != null) {
      if (serialNo.isEmpty) {
        emit(ScanItemError(message: 'Serial number is required'));
        return;
      }
    }
    emit(ScanItemLoading());
    try {
      // check if the ssccNo is already scanned
      if (_scannedItems.containsKey(serialNo ?? palletCode)) {
        emit(ScanItemError(message: 'Packaging already scanned'));
        return;
      }

      final path =
          palletCode != null
              ? '/api/scanPackaging/sscc?ssccNo=$palletCode'
              : '/api/ssccPackaging/details?serialNo=$serialNo&association=true';

      // call the API
      final response = await _httpService.request(path);

      if (response.success) {
        // If we are scanning by pallet
        if (palletCode != null) {
          if (response.data['level'] == 'container') {
            final containerData = ContainerResponseModel.fromJson(
              response.data,
            );

            // Initialize an empty list for this ssccNo if it doesn't exist yet
            if (!_scannedItems.containsKey(palletCode)) {
              _scannedItems[palletCode] = [];
            }

            for (final pallet in containerData.container.pallets) {
              for (final ssccPackage in pallet.ssccPackages) {
                for (final detail in ssccPackage.details) {
                  _scannedItems[palletCode]!.add({
                    "ssccNo": ssccPackage.ssccNo,
                    "description": ssccPackage.description,
                    "memberId": ssccPackage.memberId,
                    "binLocationId": ssccPackage.binLocationId,
                    "masterPackagingId": detail.masterPackagingId,
                    "serialGTIN": detail.serialGTIN,
                    "serialNo": detail.serialNo,
                  });
                }
              }
            }
          } else if (response.data['level'] == 'pallet') {
            final palletData = PalletResponseModel.fromJson(response.data);

            // Initialize an empty list for this ssccNo if it doesn't exist yet
            if (!_scannedItems.containsKey(palletCode)) {
              _scannedItems[palletCode] = [];
            }

            for (final pallet in palletData.pallet.ssccPackages) {
              for (final detail in pallet.details) {
                _scannedItems[palletCode]!.add({
                  "ssccNo": pallet.ssccNo,
                  "description": pallet.description,
                  "memberId": pallet.memberId,
                  "binLocationId": pallet.binLocationId,
                  "masterPackagingId": detail.masterPackagingId,
                  "serialGTIN": detail.serialGTIN,
                  "serialNo": detail.serialNo,
                });
              }
            }
          } else if (response.data['level'] == 'sscc') {
            final ssccData = SSCCResponseModel.fromJson(response.data);

            // Initialize an empty list for this ssccNo if it doesn't exist yet
            if (!_scannedItems.containsKey(palletCode)) {
              _scannedItems[palletCode] = [];
            }

            for (final detail in ssccData.sscc.details) {
              _scannedItems[palletCode]!.add({
                "ssccNo": ssccData.sscc.ssccNo,
                "description": ssccData.sscc.description,
                "memberId": ssccData.sscc.memberId,
                "binLocationId": ssccData.sscc.binLocationId,
                "masterPackagingId": detail.masterPackagingId,
                "serialGTIN": detail.serialGTIN,
                "serialNo": detail.serialNo,
              });
            }
          }
        }
        // If we are scanning by serial
        else if (serialNo != null) {
          final serialResponse = SerialResponseModel.fromJson(response.data);
          // Initialize an empty list for this ssccNo if it doesn't exist yet
          if (!_scannedItems.containsKey(serialNo)) {
            _scannedItems[serialNo] = [];
          }

          for (final item in serialResponse.data.items) {
            _scannedItems[serialNo]!.add({
              "ssccNo": item.masterPackaging.ssccNo,
              "description": item.masterPackaging.description,
              "memberId": item.masterPackaging.memberId,
              "binLocationId": item.masterPackaging.binLocationId,
              "masterPackagingId": item.masterPackaging.id,
              "serialGTIN": item.serialGTIN,
              "serialNo": item.serialNo,
            });
          }
        }

        // Make sure to emit state change to trigger UI update
        emit(ScanItemLoaded());
      } else {
        final errorMessage =
            response.data?['message'] ?? 'Failed to scan packaging';
        emit(ScanItemError(message: errorMessage));
      }
    } catch (error) {
      emit(ScanItemError(message: error.toString()));
    }
  }

  void scanBySerialOrPallet({String? palletCode, String? serialNo}) async {
    if (state is ScanItemLoading) {
      return;
    }

    if (palletCode != null) {
      if (palletCode.isEmpty) {
        emit(ScanItemError(message: 'Pallet code is required'));
        return;
      }
    } else if (serialNo != null) {
      if (serialNo.isEmpty) {
        emit(ScanItemError(message: 'Serial number is required'));
        return;
      }
    }
    emit(ScanItemLoading());
    try {
      // check if the ssccNo is already scanned
      if (_productOnPallets.containsKey(serialNo ?? palletCode)) {
        emit(
          ScanItemError(
            message:
                '${serialNo != null ? "Serial" : "Pallet ID"} already scanned!',
          ),
        );
        return;
      }

      // Check if you have specific serial number already in the list
      _productOnPallets.values.forEach((p) {
        if (p.any((x) => x.serialNumber == serialNo)) {
          emit(
            ScanItemError(
              message:
                  '${serialNo != null ? "Serial" : "Pallet ID"} already scanned!',
            ),
          );
          return;
        }
      });

      final productOnPallets = await ProductOnPalletRepository.instance
          .getProductOnPallets(
            palletCode: palletCode,
            serialNo: serialNo,
            gln: selectedBinLocation?.gln.toString() ?? '',
          );

      if (!_productOnPallets.containsKey(serialNo ?? palletCode!)) {
        _productOnPallets[serialNo ?? palletCode!] = [];
      }
      _productOnPallets[serialNo ?? palletCode!]?.addAll(productOnPallets);
      // Make sure to emit state change to trigger UI update
      emit(ScanItemLoaded());
    } catch (error) {
      emit(ScanItemError(message: error.toString()));
    }
  }

  void scanVehicleLocation(String binNumber) async {
    try {
      emit(state is ScanBinLocationLoading ? state : ScanBinLocationLoading());
      final result = await _vehicleRepository.scanDriverBinNumber(binNumber);

      if (result.isNotEmpty) {
        isSaveButtonEnabled = true;
        emit(ScanBinLocationLoaded(message: result));
      } else {
        emit(ScanBinLocationError(message: 'Failed to scan bin location'));
      }
    } catch (error) {
      emit(ScanBinLocationError(message: error.toString()));
    }
  }

  void pickItems() async {
    try {
      if (state is PickItemsLoading) return;
      if (isSaveButtonEnabled == false) {
        emit(PickItemsError(message: 'Please select items to pick'));
        return;
      }

      emit(PickItemsLoading());
      if (selectedItems.isEmpty) {
        emit(PickItemsError(message: 'No items selected'));
        return;
      }

      final success = await ProductOnPalletRepository.instance.pickItems(
        productOnPalletIds: selectedItems.values.expand((x) => x).toList(),
        salesInvoiceDetailId: salesInvoiceDetails?.id.toString() ?? '',
        quantityPicked: quantityPicked,
      );

      if (success) {
        // reset everything
        init();
        emit(PickItemsLoaded());
      } else {
        emit(PickItemsError(message: 'Failed to pick items'));
      }
    } catch (e) {
      emit(PickItemsError(message: e.toString()));
    }
  }

  void clearScannedItems() {
    _scannedItems.clear();
    _productOnPallets.clear();
    _selectedProductsOnPallet.clear();
    quantityPicked = int.parse(salesInvoiceDetails?.quantityPicked ?? "0");
    emit(ScanItemLoaded());
  }

  /*
  ##############################################################################
  ! Selection Methods
  ##############################################################################
  */
  void toggleItemSelection(String packageCode, String itemId) {
    // Initialize the selected set for this key if needed
    if (!_selectedProductsOnPallet.containsKey(packageCode)) {
      _selectedProductsOnPallet[packageCode] = <String>{};
    }

    // Toggle selection
    if (_selectedProductsOnPallet[packageCode]!.contains(itemId)) {
      _selectedProductsOnPallet[packageCode]!.remove(itemId);
      if (quantityPicked > 0) quantityPicked--;
    } else {
      if (quantityPicked < int.parse(salesInvoiceDetails?.quantity ?? "0")) {
        _selectedProductsOnPallet[packageCode]!.add(itemId);
        quantityPicked++;
      } else {
        emit(
          ScanItemError(
            message:
                "Quantity picked cannot exceed ${salesInvoiceDetails?.quantity}",
          ),
        );
      }
    }

    emit(SelectionChanged());
  }

  bool isItemSelected(String packageCode, String itemId) {
    if (!_selectedProductsOnPallet.containsKey(packageCode)) {
      return false;
    }
    return _selectedProductsOnPallet[packageCode]!.contains(itemId);
  }

  void clearSelectedItems() {
    _selectedProductsOnPallet.clear();
    emit(SelectionChanged());
  }

  List<ProductOnPallet> getSelectedProducts() {
    final selectedProducts = <ProductOnPallet>[];

    _selectedProductsOnPallet.forEach((packageCode, selectedIds) {
      final itemsForKey = _productOnPallets[packageCode] ?? [];
      for (final item in itemsForKey) {
        final itemId = item.id ?? '${item.serialNumber}-${item.palletId}';
        if (selectedIds.contains(itemId)) {
          selectedProducts.add(item);
        }
      }
    });

    return selectedProducts;
  }
}
