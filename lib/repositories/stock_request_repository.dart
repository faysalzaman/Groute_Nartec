import '../core/services/http_service.dart';

class StockRequestRepository {
  static final StockRequestRepository instance = StockRequestRepository._();

  factory StockRequestRepository() => instance;

  StockRequestRepository._();

  final _httpService = HttpService();

  Future<String> requestStocks(List<String> stockIds) async {
    final path = '/api/v1/stock-requests/add-bulk';

    final response = await _httpService.request(
      path,
      method: HttpMethod.post,
      payload: {'productOnPalletIds': stockIds},
    );

    if (response.success) {
      return response.data['message'] as String;
    } else {
      throw Exception('Failed to load bin locations');
    }
  }
}
