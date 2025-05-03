import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/models/sales_order.dart';

class SalesController {
  final HttpService _httpService = HttpService();

  Future<List<SalesOrderModel>> getSalesOrders(int page, int limit) async {
    String? token = await AppPreferences.getAccessToken();

    final path = 'v1/sales-orders/driver?page=$page&limit=$limit';

    final response = await _httpService.request(
      path,
      method: HttpMethod.get,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.success) {
      final data = response.data['data']['salesOrders'] as List;
      return data.map((order) => SalesOrderModel.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load sales orders');
    }
  }
}
