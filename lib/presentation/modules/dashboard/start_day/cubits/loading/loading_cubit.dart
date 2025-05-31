import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/bin_location_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/gs1_product.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/container_response_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/pallet_response_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/serial_response_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/sscc_response_model.dart';
import 'package:groute_nartec/repositories/bin_location_repository.dart';
import 'package:groute_nartec/repositories/product_on_pallet_repository.dart';
import 'package:groute_nartec/repositories/vehicle_repository.dart';

import '../../models/loading/product_on_pallet.dart';

part 'loading_states.dart';

/// Manages the complete loading process workflow including bin location management,
/// product scanning, item selection, and final picking operations.
class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingInitial());

  static LoadingCubit get(context) => BlocProvider.of(context);

  // ==================== DEPENDENCIES ====================

  final BinLocationRepository _binLocationRepository = BinLocationRepository();
  final VehicleRepository _vehicleRepository = VehicleRepository();
  final HttpService _httpService = HttpService(baseUrl: kGTrackUrl);

  // ==================== STATE VARIABLES ====================

  SalesInvoiceDetails? salesInvoiceDetails;
  BinLocationModel? selectedBinLocation;
  bool _byPallet = true;
  bool _bySerial = false;
  int quantityPicked = 0;
  bool isSaveButtonEnabled = false;
  Product? product;

  // ==================== COLLECTIONS ====================

  List<BinLocationModel> _binLocations = [];
  final Map<String, List<Map<dynamic, dynamic>>> _scannedItems = {};
  final Map<String, List<ProductOnPallet>> _productOnPallets = {};
  final Map<String, Set<String>> _selectedProductsOnPallet = {};

  // ==================== GETTERS ====================

  List<BinLocationModel> get binLocations => _binLocations;
  bool get byPallet => _byPallet;
  bool get bySerial => _bySerial;
  Map<String, List<Map<dynamic, dynamic>>> get scannedItems => _scannedItems;
  Map<String, List<ProductOnPallet>> get productOnPallets => _productOnPallets;
  Map<String, Set<String>> get selectedItems => _selectedProductsOnPallet;

  int get totalItemsCount {
    int count = 0;
    _productOnPallets.forEach((_, items) {
      count += items.length;
    });
    return count;
  }

  int get totalSelectedItemsCount {
    int count = 0;
    _selectedProductsOnPallet.forEach((_, items) {
      count += items.length;
    });
    return count;
  }

  // ==================== INITIALIZATION ====================

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

  // ==================== BIN LOCATION MANAGEMENT ====================

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

  // ==================== PACKAGING SCANNING ====================

  void scanPackagingBySscc({String? palletCode, String? serialNo}) async {
    if (state is ScanItemLoading) return;

    // Input validation
    if (palletCode != null && palletCode.isEmpty) {
      emit(ScanItemError(message: 'Pallet code is required'));
      return;
    }
    if (serialNo != null && serialNo.isEmpty) {
      emit(ScanItemError(message: 'Serial number is required'));
      return;
    }

    emit(ScanItemLoading());
    try {
      // Check for duplicates
      if (_scannedItems.containsKey(serialNo ?? palletCode)) {
        emit(ScanItemError(message: 'Packaging already scanned'));
        return;
      }

      final path =
          palletCode != null
              ? '/api/scanPackaging/sscc?ssccNo=$palletCode'
              : '/api/ssccPackaging/details?serialNo=$serialNo&association=true';

      final response = await _httpService.request(path);

      if (response.success) {
        if (palletCode != null) {
          await _processPalletScanResult(response.data, palletCode);
        } else if (serialNo != null) {
          await _processSerialScanResult(response.data, serialNo);
        }
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

  Future<void> _processPalletScanResult(
    Map<String, dynamic> data,
    String palletCode,
  ) async {
    if (!_scannedItems.containsKey(palletCode)) {
      _scannedItems[palletCode] = [];
    }

    switch (data['level']) {
      case 'container':
        final containerData = ContainerResponseModel.fromJson(data);
        _processContainerData(containerData, palletCode);
        break;
      case 'pallet':
        final palletData = PalletResponseModel.fromJson(data);
        _processPalletData(palletData, palletCode);
        break;
      case 'sscc':
        final ssccData = SSCCResponseModel.fromJson(data);
        _processSSCCData(ssccData, palletCode);
        break;
    }
  }

  void _processContainerData(
    ContainerResponseModel containerData,
    String palletCode,
  ) {
    for (final pallet in containerData.container.pallets) {
      for (final ssccPackage in pallet.ssccPackages) {
        for (final detail in ssccPackage.details) {
          _scannedItems[palletCode]!.add(_createItemMap(ssccPackage, detail));
        }
      }
    }
  }

  void _processPalletData(PalletResponseModel palletData, String palletCode) {
    for (final pallet in palletData.pallet.ssccPackages) {
      for (final detail in pallet.details) {
        _scannedItems[palletCode]!.add(_createItemMap(pallet, detail));
      }
    }
  }

  void _processSSCCData(SSCCResponseModel ssccData, String palletCode) {
    for (final detail in ssccData.sscc.details) {
      _scannedItems[palletCode]!.add(
        _createItemMapFromSSCC(ssccData.sscc, detail),
      );
    }
  }

  Future<void> _processSerialScanResult(
    Map<String, dynamic> data,
    String serialNo,
  ) async {
    final serialResponse = SerialResponseModel.fromJson(data);

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

  Map<String, dynamic> _createItemMap(dynamic ssccPackage, dynamic detail) {
    return {
      "ssccNo": ssccPackage.ssccNo,
      "description": ssccPackage.description,
      "memberId": ssccPackage.memberId,
      "binLocationId": ssccPackage.binLocationId,
      "masterPackagingId": detail.masterPackagingId,
      "serialGTIN": detail.serialGTIN,
      "serialNo": detail.serialNo,
    };
  }

  Map<String, dynamic> _createItemMapFromSSCC(dynamic sscc, dynamic detail) {
    return {
      "ssccNo": sscc.ssccNo,
      "description": sscc.description,
      "memberId": sscc.memberId,
      "binLocationId": sscc.binLocationId,
      "masterPackagingId": detail.masterPackagingId,
      "serialGTIN": detail.serialGTIN,
      "serialNo": detail.serialNo,
    };
  }

  // ==================== PRODUCT SCANNING ====================

  void scanBySerialOrPallet({String? palletCode, String? serialNo}) async {
    if (state is ScanItemLoading) return;

    // Input validation
    if (palletCode != null && palletCode.isEmpty) {
      emit(ScanItemError(message: 'Pallet code is required'));
      return;
    }
    if (serialNo != null && serialNo.isEmpty) {
      emit(ScanItemError(message: 'Serial number is required'));
      return;
    }

    emit(ScanItemLoading());
    try {
      // Check for duplicate package scans
      if (_productOnPallets.containsKey(serialNo ?? palletCode)) {
        emit(
          ScanItemError(
            message:
                '${serialNo != null ? "Serial" : "Pallet ID"} already scanned!',
          ),
        );
        return;
      }

      // Check for duplicate serial numbers across all packages
      for (var productList in _productOnPallets.values) {
        if (productList.any((x) => x.serialNumber == serialNo)) {
          emit(
            ScanItemError(
              message:
                  '${serialNo != null ? "Serial" : "Pallet ID"} already scanned!',
            ),
          );
          return;
        }
      }

      final productOnPallets = await ProductOnPalletRepository.instance
          .getProductOnPallets(
            palletCode: palletCode,
            serialNo: serialNo,
            gln: selectedBinLocation?.gln.toString() ?? '',
            productId: "${product?.id}",
          );

      final key = serialNo ?? palletCode!;
      if (!_productOnPallets.containsKey(key)) {
        _productOnPallets[key] = [];
      }
      _productOnPallets[key]?.addAll(productOnPallets);

      emit(ScanItemLoaded());
    } catch (error) {
      emit(ScanItemError(message: error.toString()));
    }
  }

  // ==================== VEHICLE LOCATION ====================

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

  // ==================== ITEM SELECTION ====================

  void toggleItemSelection(String packageCode, String itemId) {
    if (!_selectedProductsOnPallet.containsKey(packageCode)) {
      _selectedProductsOnPallet[packageCode] = <String>{};
    }

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
        return;
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
    quantityPicked = 0;
    emit(SelectionChanged());
  }

  void selectAllItems() {
    clearSelectedItems();

    final int maxQuantity = int.parse(salesInvoiceDetails?.quantity ?? "0");
    int selectedCount = 0;

    for (var entry in _productOnPallets.entries) {
      String packageCode = entry.key;
      List<ProductOnPallet> items = entry.value;

      if (!_selectedProductsOnPallet.containsKey(packageCode)) {
        _selectedProductsOnPallet[packageCode] = <String>{};
      }

      for (var item in items) {
        if (selectedCount >= maxQuantity) break;

        final itemId = item.id ?? '${item.serialNumber}-${item.palletId}';
        _selectedProductsOnPallet[packageCode]!.add(itemId);
        selectedCount++;
      }

      if (selectedCount >= maxQuantity) break;
    }

    quantityPicked = selectedCount;
    emit(SelectionChanged());
  }

  bool areAllItemsSelected() {
    final int maxQuantity = int.parse(salesInvoiceDetails?.quantity ?? "0");
    return totalSelectedItemsCount >= maxQuantity ||
        (totalItemsCount > 0 && totalSelectedItemsCount == totalItemsCount);
  }

  // ==================== ITEM MANAGEMENT ====================

  void removeItem(String packageCode, ProductOnPallet item) {
    final String itemId = item.id ?? '${item.serialNumber}-${item.palletId}';

    // Deselect if currently selected
    if (_selectedProductsOnPallet.containsKey(packageCode) &&
        _selectedProductsOnPallet[packageCode]!.contains(itemId)) {
      _selectedProductsOnPallet[packageCode]!.remove(itemId);
      quantityPicked--;
    }

    // Remove from product list
    if (_productOnPallets.containsKey(packageCode)) {
      _productOnPallets[packageCode]!.removeWhere((palletItem) {
        final currentItemId =
            palletItem.id ??
            '${palletItem.serialNumber}-${palletItem.palletId}';
        return currentItemId == itemId;
      });

      // Remove empty package
      if (_productOnPallets[packageCode]!.isEmpty) {
        _productOnPallets.remove(packageCode);
      }
    }

    emit(ItemRemoved());
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

  void clearScannedItems() {
    _scannedItems.clear();
    _productOnPallets.clear();
    _selectedProductsOnPallet.clear();
    quantityPicked = int.parse(salesInvoiceDetails?.quantityPicked ?? "0");
    emit(ScanItemLoaded());
  }

  // ==================== PICK OPERATIONS ====================

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

      final selectedItemsIds = selectedItems.values.expand((x) => x).toList();

      final success = await ProductOnPalletRepository.instance.pickItems(
        productOnPalletIds: selectedItemsIds,
        salesInvoiceDetailId: salesInvoiceDetails?.id.toString() ?? '',
        quantityPicked: quantityPicked,
        gln: "${selectedBinLocation?.gln}",
        binNumber: "${selectedBinLocation?.binNumber}",
      );

      if (success) {
        init();
        emit(PickItemsLoaded());
      } else {
        emit(PickItemsError(message: 'Failed to pick items'));
      }
    } catch (e) {
      emit(PickItemsError(message: e.toString()));
    }
  }
}
