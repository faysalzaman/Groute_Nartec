import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/presentation/modules/auth/models/driver_model.dart';

class DriverRepositry {
  final HttpService _httpService = HttpService();

  Future<Driver?> login(String email, String password) async {
    final path = 'v1/drivers/login';

    final response = await _httpService.request(
      path,
      method: HttpMethod.post,
      payload: {'email': email, 'password': password},
    );

    if (response.success) {
      final data = response.data['data'];

      // Extract tokens from response
      final accessToken = data['accessToken'];

      if (accessToken == null) {
        throw Exception('Access token not found in response');
      }

      // Save access token
      await AppPreferences.setAccessToken(accessToken);

      // Parse driver data
      final Driver driver = Driver.fromJson(data['driver']);

      // Save driver data to SharedPreferences
      await AppPreferences.saveDriver(driver);

      return driver;
    }
    return null;
  }

  Future<Driver?> loginWithNfc(String nfcNumber) async {
    final path = 'v1/drivers/login?nfcLogin=$nfcNumber';

    final response = await _httpService.request(
      path,
      method: HttpMethod.post,
      payload: {'nfcNumber': nfcNumber},
    );

    if (response.success) {
      final data = response.data['data'];

      // Extract tokens from response
      final accessToken = data['accessToken'];

      if (accessToken == null) {
        throw Exception('Access token not found in response');
      }

      // Save access token
      await AppPreferences.setAccessToken(accessToken);

      // Parse driver data
      final Driver driver = Driver.fromJson(data['driver']);

      // Save driver data to SharedPreferences
      await AppPreferences.saveDriver(driver);

      return driver;
    }
    return null;
  }

  // Add a logout method to clear stored data
  Future<void> logout() async {
    await AppPreferences.clearAllData();
  }
}
