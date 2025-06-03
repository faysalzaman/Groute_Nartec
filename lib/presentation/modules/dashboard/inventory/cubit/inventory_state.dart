import 'package:groute_nartec/presentation/modules/dashboard/inventory/model/stocks_availability_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/model/stocks_on_van_model.dart';

class InventoryState {}

class InventoryInitial extends InventoryState {}

class StocksOnVanLoading extends InventoryState {}

class StocksOnVanLoaded extends InventoryState {
  final List<StocksOnVanModel> stocks;

  StocksOnVanLoaded(this.stocks);
}

class StocksOnVanError extends InventoryState {
  final String error;

  StocksOnVanError(this.error);
}

class StocksAvailabilityLoading extends InventoryState {}

class StocksAvailabilityLoaded extends InventoryState {
  final List<StocksAvailablityModel> stocks;

  StocksAvailabilityLoaded(this.stocks);
}

class StocksAvailabilityError extends InventoryState {
  final String error;

  StocksAvailabilityError(this.error);
}
