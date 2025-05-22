import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/bin_location_model.dart';

import '../core/services/http_service.dart';

class BinLocationRepository {
  static final BinLocationRepository instance = BinLocationRepository._();

  factory BinLocationRepository() => instance;

  BinLocationRepository._();

  final _httpService = HttpService();

  Future<List<BinLocationModel>> getSuggestedBins(String productId) async {
    final path =
        '/api/v1/bin-locations/product/$productId?page=1&limit=1000000';

    final response = await _httpService.request(path);

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
