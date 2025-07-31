import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/product_on_pallet.dart';
import 'package:groute_nartec/repositories/stock_on_van_repository.dart';

part 'request_stock_state.dart';

/// Manages the request van stock workflow including product scanning and item selection
class RequestStockCubit extends Cubit<RequestStockState> {
  RequestStockCubit() : super(RequestStockInitial());

  static RequestStockCubit get(context) => BlocProvider.of(context);

  // ==================== STATE VARIABLES ====================

  bool _byPallet = true;
  bool _bySerial = false;
  int quantityPicked = 0;

  // ==================== COLLECTIONS ====================

  final Map<String, List<ProductOnPallet>> _productOnPallets = {};
  final Map<String, List<ProductOnPallet>> _productOnPalletsAdded = {};
  final Map<String, Set<String>> _selectedProductsOnPallet = {};

  // ==================== GETTERS ====================

  bool get byPallet => _byPallet;
  bool get bySerial => _bySerial;
  Map<String, List<ProductOnPallet>> get productOnPallets => _productOnPallets;
  Map<String, List<ProductOnPallet>> get productOnPalletsAdded =>
      _productOnPalletsAdded;
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
    _productOnPallets.clear();
    _selectedProductsOnPallet.clear();
    _productOnPalletsAdded.clear();
    quantityPicked = 0;
    emit(RequestStockChangeScanType());
  }

  void setScanType(bool byPallet, bool bySerial) {
    _byPallet = byPallet;
    _bySerial = bySerial;
    emit(RequestStockChangeScanType());
  }

  // ==================== PRODUCT SCANNING ====================

  void scanBySerialOrPallet({String? palletCode, String? serialNo}) async {
    if (state is RequestStockScanItemLoading) return;

    // Input validation
    if (palletCode != null && palletCode.isEmpty) {
      emit(RequestStockScanItemError(message: 'Pallet code is required'));
      return;
    }
    if (serialNo != null && serialNo.isEmpty) {
      emit(RequestStockScanItemError(message: 'Serial number is required'));
      return;
    }

    emit(RequestStockScanItemLoading());

    try {
      // Check for duplicate package scans
      if (_productOnPallets.containsKey(serialNo ?? palletCode)) {
        emit(
          RequestStockScanItemError(
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
            RequestStockScanItemError(
              message:
                  '${serialNo != null ? "Serial" : "Pallet ID"} already scanned!',
            ),
          );
          return;
        }
      }

      final productOnPallets = await StockOnVanRepository.instance
          .getByPalletOrSerial(palletCode: palletCode, serialNo: serialNo);

      final key = serialNo ?? palletCode!;
      if (!_productOnPallets.containsKey(key)) {
        _productOnPallets[key] = [];
      }
      _productOnPallets[key]?.addAll(productOnPallets);

      emit(RequestStockScanItemLoaded());
    } catch (error) {
      emit(RequestStockScanItemError(message: error.toString()));
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
      _selectedProductsOnPallet[packageCode]!.add(itemId);
      quantityPicked++;
    }

    emit(RequestStockSelectionChanged());
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
    emit(RequestStockSelectionChanged());
  }

  void selectAllItems() {
    clearSelectedItems();

    int selectedCount = 0;

    for (var entry in _productOnPallets.entries) {
      String packageCode = entry.key;
      List<ProductOnPallet> items = entry.value;

      if (!_selectedProductsOnPallet.containsKey(packageCode)) {
        _selectedProductsOnPallet[packageCode] = <String>{};
      }

      for (var item in items) {
        final itemId = item.id ?? '${item.serialNumber}-${item.palletId}';
        _selectedProductsOnPallet[packageCode]!.add(itemId);
        selectedCount++;
      }
    }

    quantityPicked = selectedCount;
    emit(RequestStockSelectionChanged());
  }

  bool areAllItemsSelected() {
    return totalItemsCount > 0 && totalSelectedItemsCount == totalItemsCount;
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

    emit(RequestStockItemRemoved());
  }

  // New method specifically for removing items from the request list
  void removeItemFromRequestList(String packageCode, ProductOnPallet item) {
    final String itemId = item.id ?? '${item.serialNumber}-${item.palletId}';

    // Remove from added products list
    if (_productOnPalletsAdded.containsKey(packageCode)) {
      _productOnPalletsAdded[packageCode]!.removeWhere((palletItem) {
        final currentItemId =
            palletItem.id ??
            '${palletItem.serialNumber}-${palletItem.palletId}';
        return currentItemId == itemId;
      });

      // Remove empty package from added list
      if (_productOnPalletsAdded[packageCode]!.isEmpty) {
        _productOnPalletsAdded.remove(packageCode);
      }
    }

    emit(RequestStockItemRemoved());
  }

  void clearScannedItems() {
    _productOnPallets.clear();
    _selectedProductsOnPallet.clear();
    quantityPicked = 0;
    emit(RequestStockScanItemLoaded());
  }

  // ==================== REQUEST OPERATIONS ====================

  void addItemsForRequest() async {
    try {
      if (state is RequestStockAddRequestItemLoading) return;

      emit(RequestStockAddRequestItemLoading());

      // add selected items to productOnPalletsAdded
      _selectedProductsOnPallet.forEach((packageCode, selectedIds) {
        final itemsForKey = _productOnPallets[packageCode] ?? [];
        final selectedItems =
            itemsForKey.where((item) {
              final itemId = item.id ?? '${item.serialNumber}-${item.palletId}';
              return selectedIds.contains(itemId);
            }).toList();
        if (selectedItems.isNotEmpty) {
          _productOnPalletsAdded[packageCode] = selectedItems;
        }
      });

      // Clear selected items after adding
      _selectedProductsOnPallet.clear();
      quantityPicked = 0;
      emit(RequestStockAddRequestItemLoaded());
    } catch (e) {
      emit(RequestStockAddRequestItemError(message: e.toString()));
    }
  }

  void requestItems() async {
    try {
      if (state is RequestStockRequestItemsLoading) return;

      if (_productOnPalletsAdded.isEmpty) {
        emit(RequestStockRequestItemsError(message: 'No items to request'));
        return;
      }

      emit(RequestStockRequestItemsLoading());

      if (productOnPalletsAdded.isEmpty) {
        emit(RequestStockRequestItemsError(message: 'No items selected'));
        return;
      }

      final selectedItemsIds = <String>[];
      _productOnPalletsAdded.forEach((packageCode, items) {
        for (final item in items) {
          final itemId = item.id ?? '${item.serialNumber}-${item.palletId}';
          selectedItemsIds.add(itemId);
        }
      });

      if (selectedItemsIds.isEmpty) {
        emit(RequestStockRequestItemsError(message: 'No items selected'));
        return;
      }

      print('Requesting van stock for items: ${selectedItemsIds.join(', ')}');

      // Call API to request van stock - you'll need to implement this in your repository

      init();
      emit(RequestStockRequestItemsLoaded());
    } catch (e) {
      emit(RequestStockRequestItemsError(message: e.toString()));
    }
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
