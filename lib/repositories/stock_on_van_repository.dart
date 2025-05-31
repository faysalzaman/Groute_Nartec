import 'dart:async';

import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/product_on_pallet.dart';

import '../core/services/http_service.dart';

class StockOnVanRepository {
  static final StockOnVanRepository instance = StockOnVanRepository._();

  factory StockOnVanRepository() => instance;

  StockOnVanRepository._();

  final _httpService = HttpService();

  Future<List<ProductOnPallet>> getProductsBySearch({
    String? palletCode,
    String? serialNo,
    required String gln,
  }) async {
    try {
      final path = '/api/v1/stock-on-van/by-pallet-or-serial';

      // final payload =
      //     palletCode != null
      //         ? {"searchTerm": palletCode, "searchType": "pallet", "gln": gln}
      //         : {"searchTerm": serialNo, "searchType": "serial", "gln": gln};

      final payload = {"searchTerm": palletCode ?? serialNo, "gln": gln};

      // call the API
      final response = await _httpService.request(
        path,
        method: HttpMethod.post,
        payload: payload,
      );

      if (response.success) {
        final productOnPallets =
            (response.data['data'] as List)
                .map((e) => ProductOnPallet.fromJson(e))
                .toList();
        return productOnPallets;
      } else {
        throw Exception('Failed to load product on pallets');
      }
    } catch (error) {
      throw Exception('Failed to load product on pallets');
    }
  }

  Future<bool> unloadItems({
    required List<String> stocksOnVanIds,
    required String salesInvoiceDetailId,
    required int quantityPicked,
  }) async {
    try {
      final path = '/api/v1/stock-on-van/unload';

      final payload = {
        "stocksOnVanIds": stocksOnVanIds,
        "salesInvoiceDetailId": salesInvoiceDetailId,
        "quantityPicked": quantityPicked.toString(),
      };

      // call the API
      final response = await _httpService.request(
        path,
        method: HttpMethod.post,
        payload: payload,
      );

      if (response.success) {
        return true;
      }

      return false;
    } catch (error) {
      throw Exception('Failed to pick items');
    }
  }

  FutureOr<bool> newUnloadItems({
    required String gtin,
    required String salesInvoiceDetailId,
  }) async {
    try {
      final path = '/api/v1/stock-on-van/unload-products';

      final payload = {
        "salesInvoiceDetailId": salesInvoiceDetailId,
        "gtin": gtin,
      };

      // call the API
      final response = await _httpService.request(
        path,
        method: HttpMethod.post,
        payload: payload,
      );

      if (response.success) {
        return true;
      }

      return false;
    } catch (error) {
      throw Exception('Failed to pick items');
    }
  }
}
