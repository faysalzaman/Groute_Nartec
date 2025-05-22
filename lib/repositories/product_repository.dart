import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/gs1_product.dart';

class Gs1Repository {
  final HttpService _grouteHttpService = HttpService();

  Future<Product> getProductById(String productId) async {
    final path = '/api/v1/products/gtin/$productId';

    final response = await _grouteHttpService.request(path);

    if (response.success) {
      final productData = response.data['data'];
      return Product.fromJson(productData);
    } else {
      throw Exception('Failed to load product details: ${response.message}');
    }
  }
}
