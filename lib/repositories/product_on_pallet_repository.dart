import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/product_on_pallet.dart';

import '../core/services/http_service.dart';

class ProductOnPalletRepository {
  static final ProductOnPalletRepository instance =
      ProductOnPalletRepository._();

  factory ProductOnPalletRepository() => instance;

  ProductOnPalletRepository._();

  final _httpService = HttpService();

  Future<List<ProductOnPallet>> getProductOnPallets({
    String? palletCode,
    String? serialNo,
    required String gln,
  }) async {
    try {
      final path = '/api/v1/product-pallets/search';

      final payload =
          palletCode != null
              ? {"searchTerm": palletCode, "searchType": "pallet", "gln": gln}
              : {"searchTerm": serialNo, "searchType": "serial", "gln": gln};

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

  Future<bool> pickItems({
    required List<String> productOnPalletIds,
    required String salesInvoiceDetailId,
    required int quantityPicked,
  }) async {
    try {
      final path = '/api/v1/product-pallets/pick';

      final payload = {
        "productOnPalletIds": productOnPalletIds,
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
}
