import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/bin_location_model.dart';

import '../core/constants/app_preferences.dart';
import '../core/services/http_service.dart';

class BinLocationRepository {
  static final BinLocationRepository instance = BinLocationRepository._();

  factory BinLocationRepository() => instance;

  BinLocationRepository._();

  final _httpService = HttpService();

  Future<List<BinLocationModel>> getBinLocations() async {
    final token = await AppPreferences.getAccessToken();

    final path = '/api/v1/bin-locations?page=1&limit=10000';

    final response = await _httpService.request(
      path,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.success) {
      final data = response.data['data']['binLocations'] as List;
      return data
          .map((binLocation) => BinLocationModel.fromJson(binLocation))
          .toList();
    } else {
      throw Exception('Failed to load bin locations');
    }
  }
}
