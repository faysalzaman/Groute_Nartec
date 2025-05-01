import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/view/screens/auth/model/login_model.dart';

class AuthController {
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
      await AppPreferences.setAccessToken(accessToken);

      final Driver driver = Driver.fromJson(data['driver']);

      // Save tokens to SharedPreferences

      return driver;
    }
    return null;
  }
}
