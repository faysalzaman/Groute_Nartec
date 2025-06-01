import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/bin_location_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/gs1_product.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/product_on_pallet.dart';
import 'package:groute_nartec/repositories/bin_location_repository.dart';
import 'package:groute_nartec/repositories/delivery_details_repository.dart';
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

  void newUnloadItems(
    List<String> gtins,
    List<String> salesInvoiceDetailIds,
    double totalPrice,
    int totalQuantity,
    String salesOrderId,
  ) async {
    try {
      if (state is UnloadItemsLoading) return;

      emit(UnloadItemsLoading());

      await StockOnVanRepository.instance.newUnloadItems(
        gtins: gtins,
        salesInvoiceDetailIds: salesInvoiceDetailIds,
        totalPrice: totalPrice,
        totalQuantity: totalQuantity,
        salesOrderId: salesOrderId,
      );

      emit(UnloadItemsLoaded());
    } catch (e) {
      emit(UnloadItemsError(message: e.toString()));
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

  Future<void> uploadSignature(
    String id,
    File image,
    String salesOrderId,
  ) async {
    emit(SalesOrderAddSignatureLoadingState());

    try {
      final salesController = DeliveryDetailsRepository();
      await salesController.uploadSignature(image, salesOrderId);
      emit(SalesOrderAddSignatureSuccessState());
    } catch (e) {
      emit(SalesOrderAddSignatureErrorState(e.toString()));
    }
  }

  Future<void> uploadImages(List<File> images, String salesOrderId) async {
    emit(SalesOrderUploadImageLoading());
    try {
      final deliveryDetailsRepository = DeliveryDetailsRepository();
      await deliveryDetailsRepository.uploadImages(images, salesOrderId);
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

  void clearScannedItems() {
    _scannedItems.clear();
    _productOnPallets.clear();
    _selectedProductsOnPallet.clear();
    quantityPicked = int.parse(
      selectedSalesInvoiceDetail?.quantityPicked ?? "0",
    );
    emit(ScanItemLoaded());
  }

  void clearSelectedItems() {
    _selectedProductsOnPallet.clear();
    quantityPicked = int.parse(
      selectedSalesInvoiceDetail?.quantityPicked ?? "0",
    );
    emit(SelectionChanged());
  }

  void selectAllItems() {
    // First clear any existing selections to avoid duplicates
    clearSelectedItems();

    // In unloading, we start with max quantity and decrement, opposite of loading
    int remainingQuantity = quantityPicked;

    // Loop through all packages and select items until we reach the maximum
    for (var entry in _productOnPallets.entries) {
      String packageCode = entry.key;
      List<ProductOnPallet> items = entry.value;

      // Initialize set for this package if needed
      if (!_selectedProductsOnPallet.containsKey(packageCode)) {
        _selectedProductsOnPallet[packageCode] = <String>{};
      }

      // Add items from this package until we reach the limit
      for (var item in items) {
        if (remainingQuantity <= 0) break;

        final itemId = item.id ?? '${item.serialNumber}-${item.palletId}';
        _selectedProductsOnPallet[packageCode]!.add(itemId);
        remainingQuantity--;
      }

      // Stop if we've reached the maximum
      if (remainingQuantity <= 0) break;
    }

    // Update quantity picked
    quantityPicked = remainingQuantity;

    emit(SelectionChanged());
  }

  bool areAllItemsSelected() {
    // For unloading, we have reached max selection if we've used all our quantity
    return quantityPicked <= 0 ||
        (totalItemsCount > 0 && totalSelectedItemsCount == totalItemsCount);
  }

  void removeItem(String packageCode, ProductOnPallet item) {
    // Get the unique ID for this item
    final String itemId = item.id ?? '${item.serialNumber}-${item.palletId}';

    // First, check if the item is selected and deselect it
    if (_selectedProductsOnPallet.containsKey(packageCode) &&
        _selectedProductsOnPallet[packageCode]!.contains(itemId)) {
      _selectedProductsOnPallet[packageCode]!.remove(itemId);
      quantityPicked++; // In unloading, removing a selected item increases available quantity
    }

    // Then remove the item from the productOnPallets map
    if (_productOnPallets.containsKey(packageCode)) {
      _productOnPallets[packageCode]!.removeWhere((palletItem) {
        final currentItemId =
            palletItem.id ??
            '${palletItem.serialNumber}-${palletItem.palletId}';
        return currentItemId == itemId;
      });

      // If the package is now empty, remove it entirely
      if (_productOnPallets[packageCode]!.isEmpty) {
        _productOnPallets.remove(packageCode);
      }
    }

    emit(ItemRemoved());
  }

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

  //###################### Unloading ######################
  void updateSalesInvoiceDetail() async {
    try {
      if (state is ProductUpdateLoading) return;
      emit(ProductUpdateLoading());

      await SalesOrderRepository().updateSalesInvoiceDetail(
        selectedSalesInvoiceDetail?.id.toString() ?? '',
      );

      emit(ProductUpdateLoaded());
    } catch (e) {
      emit(ProductUpdateError(message: e.toString()));
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

  List<SalesInvoiceDetails> salesInvoiceDetailsList = [];

  void getSalesInvoiceDetailsbySalesOrderId(String salesOrderId) async {
    try {
      emit(SalesInvoiceDetailsLoading());

      final salesController = SalesOrderRepository();

      salesInvoiceDetailsList = await salesController
          .getSalesDetailsBySalesOrderId(salesOrderId);

      if (salesInvoiceDetailsList.isNotEmpty) {
        emit(SalesInvoiceDetailsLoaded(salesInvoiceDetailsList));
      }
    } catch (e) {
      emit(SalesInvoiceDetailsError(message: e.toString()));
    }
  }
}
