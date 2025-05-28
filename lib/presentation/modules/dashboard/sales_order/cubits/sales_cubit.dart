import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/bin_location_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/gs1_product.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/product_on_pallet.dart';
import 'package:groute_nartec/repositories/bin_location_repository.dart';
import 'package:groute_nartec/repositories/sales_order_repository.dart';
import 'package:groute_nartec/repositories/stock_on_van_repository.dart';
import 'package:groute_nartec/repositories/vehicle_repository.dart';

import 'sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  SalesCubit({SalesOrderRepository? controller}) : super(SalesInitial());

  static SalesCubit get(context) => BlocProvider.of<SalesCubit>(context);

  // Repositories
  final _binLocationRepository = BinLocationRepository();

  // Selected
  SalesInvoiceDetails? selectedSalesInvoiceDetail;
  BinLocationModel? selectedBinLocation;
  Product? product;
  bool _byPallet = true;
  bool _bySerial = false;
  int quantityPicked = 0;
  bool isSaveButtonEnabled = false;

  // Lists
  List<SalesOrderModel> salesOrders = [];
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

  // Others

  Future<void> getSalesOrder(int page, int limit) async {
    emit(SalesLoading());

    try {
      final salesController = SalesOrderRepository();
      final salesOrders = await salesController.getSalesOrders(
        page,
        limit,
        // status: "Loaded",
      );
      this.salesOrders = salesOrders;

      if (salesOrders.isNotEmpty) {
        emit(SalesLoaded(salesOrders));
      }
    } catch (e) {
      emit(SalesError(e.toString()));
    }
  }

  Future<void> updateStatus(String id, Map<String, dynamic> body) async {
    emit(SalesStatusUpdateLoadingState());

    try {
      final salesController = SalesOrderRepository();
      await salesController.updateStatus(id, body);
      emit(SalesStatusUpdateSuccessState());
    } catch (e) {
      emit(SalesStatusUpdateErrorState(e.toString()));
    }
  }

  Future<void> uploadSignature(String id, File image) async {
    emit(SalesOrderAddSignatureLoadingState());

    try {
      final salesController = SalesOrderRepository();
      await salesController.uploadSignature(image, id);
      emit(SalesOrderAddSignatureSuccessState());
    } catch (e) {
      emit(SalesOrderAddSignatureErrorState(e.toString()));
    }
  }

  Future<void> uploadImages(
    List<File> images,
    String orderId,
    String productId,
  ) async {
    emit(SalesOrderUploadImageLoading());
    try {
      final salesController = SalesOrderRepository();
      await salesController.uploadImages(images, orderId, productId);
      emit(SalesOrderUploadImageSuccess());
    } catch (e) {
      emit(SalesOrderUploadImageError(e.toString()));
    }
  }

  /*
    !     Bin Location        !
  */

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
    selectedBinLocation = _binLocations.firstWhere(
      (binLocation) => binLocation.binNumber == binNumber.split("-").first,
    );
    emit(BinLocationLoaded());
  }

  /*
  !    Unloading Items     !
  */

  void init() {
    _byPallet = true;
    _bySerial = false;
    _scannedItems.clear();
    _productOnPallets.clear();
    _selectedProductsOnPallet.clear();
    quantityPicked = int.parse(
      selectedSalesInvoiceDetail?.quantityPicked ?? "0",
    );
    isSaveButtonEnabled = false;
    emit(ChangeScanType());
  }

  void setScanType(bool byPallet, bool bySerial) {
    _byPallet = byPallet;
    _bySerial = bySerial;
    print("Scan Type: $_byPallet, $_bySerial");
    emit(ChangeScanType());
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

      final productOnPallets = await StockOnVanRepository.instance
          .getProductsBySearch(
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
      final result = await VehicleRepository.instance.scanDriverBinNumber(
        binNumber,
      );

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

  void unloadItems() async {
    try {
      if (state is UnloadItemsLoading) return;
      if (isSaveButtonEnabled == false) {
        emit(UnloadItemsError(message: 'Please select items to pick'));
        return;
      }

      emit(UnloadItemsLoading());
      if (selectedItems.isEmpty) {
        emit(UnloadItemsError(message: 'No items selected'));
        return;
      }

      final selectedItemsIds = selectedItems.values.expand((x) => x).toList();

      final success = await StockOnVanRepository.instance.unloadItems(
        stocksOnVanIds: selectedItemsIds,
        salesInvoiceDetailId: selectedSalesInvoiceDetail?.id.toString() ?? '',
        quantityPicked: quantityPicked,
      );

      if (success) {
        // reset everything
        init();
        emit(UnloadItemsLoaded());
      } else {
        emit(UnloadItemsError(message: 'Failed to pick items'));
      }
    } catch (e) {
      emit(UnloadItemsError(message: e.toString()));
    }
  }

  void clearScannedItems() {
    _scannedItems.clear();
    _productOnPallets.clear();
    _selectedProductsOnPallet.clear();
    quantityPicked = int.parse(
      selectedSalesInvoiceDetail?.quantityPicked ?? "0",
    );
    emit(ScanItemLoaded());
  }

  /*
  !   Selection Methods  !
  */

  void toggleItemSelection(String packageCode, String itemId) {
    // Initialize the selected set for this key if needed
    if (!_selectedProductsOnPallet.containsKey(packageCode)) {
      _selectedProductsOnPallet[packageCode] = <String>{};
    }

    // Toggle selection
    if (_selectedProductsOnPallet[packageCode]!.contains(itemId)) {
      _selectedProductsOnPallet[packageCode]?.remove(itemId);
      if (quantityPicked >= 0) quantityPicked++;
    } else {
      if (quantityPicked > 0) {
        _selectedProductsOnPallet[packageCode]?.add(itemId);
        quantityPicked--;
      } else {
        emit(ScanItemError(message: "You have reached your max limit"));
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
