import '../core/services/http_service.dart';

class VehicleRepository {
  static final VehicleRepository instance = VehicleRepository._();

  factory VehicleRepository() => instance;

  VehicleRepository._();

  final _httpService = HttpService();

  Future<String> scanDriverBinNumber(String binNumber) async {
    final path = '/api/v1/vehicles/scanBin/$binNumber';

    final response = await _httpService.request(path);

    if (response.success) {
      return response.data['message'] as String;
    } else {
      throw Exception('Failed to load bin locations');
    }
  }
}
