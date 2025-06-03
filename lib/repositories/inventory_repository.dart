import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/model/stocks_on_van_model.dart';

import '../core/services/http_service.dart';

class InventoryRepository {
  static final InventoryRepository instance = InventoryRepository._();

  factory InventoryRepository() => instance;

  InventoryRepository._();

  final _httpService = HttpService();

  Future<List<StocksOnVanModel>> getStocksOnVan(
    int page,
    int limit,
    String search,
  ) async {
    final token = await AppPreferences.getAccessToken();
    final driverId = await AppPreferences.getDriverVehicleId();

    final path =
        '/api/v1/stock-on-van/vehicle/$driverId?page=$page&limit=$limit&search=$search';

    final response = await _httpService.request(
      path,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.success) {
      final data = response.data['data']['stockOnVans'] as List;
      return data.map((item) => StocksOnVanModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load bin locations');
    }
  }
}
