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
    required String productId,
  }) async {
    try {
      final path = '/api/v1/product-pallets/by-pallet-or-serial';

      final payload = {
        "searchTerm": palletCode ?? serialNo,
        "gln": gln,
        "productId": productId,
      };

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
    required String gln,
    required String binNumber,
  }) async {
    try {
      final path = '/api/v1/product-pallets/pick';

      final payload = {
        "productOnPalletIds": productOnPalletIds,
        "salesInvoiceDetailId": salesInvoiceDetailId,
        "quantityPicked": quantityPicked.toString(),
        "gln": gln,
        "binNumber": binNumber,
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
