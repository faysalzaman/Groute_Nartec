import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/gs1_product.dart';

class Gs1Repository {
  final HttpService _httpService = HttpService(baseUrl: kGS1Url);

  Future<GS1Product> getGS1ProductDetails(String barcode) async {
    final gtrackToken = await AppPreferences.getGTrackToken();
    final path =
        '/api/products/paginatedProducts?page=1&pageSize=10&barcode=$barcode';

    final response = await _httpService.request(
      path,
      headers: {
        'Authorization': 'Bearer $gtrackToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.success) {
      final data = response.data['products'] as List<dynamic>;
      if (data.isNotEmpty) {
        return GS1Product.fromJson(data[0]);
      } else {
        throw Exception('No product found for the given barcode');
      }
    } else {
      throw Exception('Failed to load GS1 product details');
    }
  }
}
