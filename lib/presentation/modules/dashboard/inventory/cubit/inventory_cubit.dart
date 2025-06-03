import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/cubit/inventory_state.dart';
import 'package:groute_nartec/repositories/inventory_repository.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit({InventoryRepository? inventoryRepository})
    : _inventoryRepository = inventoryRepository ?? InventoryRepository(),
      super(InventoryInitial());

  final InventoryRepository _inventoryRepository;

  Future<void> getStocksOnVan(int page, int limit, String search) async {
    emit(StocksOnVanLoading());
    try {
      final stocks = await _inventoryRepository.getStocksOnVan(
        page,
        limit,
        search,
      );
      emit(StocksOnVanLoaded(stocks));
    } catch (e) {
      emit(StocksOnVanError(e.toString()));
    }
  }
}
