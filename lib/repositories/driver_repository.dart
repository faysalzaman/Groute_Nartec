import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/presentation/modules/auth/models/driver_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/view_asssigned_route_model.dart';

class DriverRepositry {
  final HttpService _httpService = HttpService();

  Future<Driver?> login(String email, String password) async {
    final path = '/api/v1/drivers/login';

    final response = await _httpService.request(
      path,
      method: HttpMethod.post,
      payload: {'email': email, 'password': password},
    );

    if (response.success) {
      final data = response.data['data'];

      // Extract tokens from response
      final accessToken = data['accessToken'];
      final gtrackToken = data['driver']['member']['token'];

      if (accessToken == null) {
        throw Exception('Access token not found in response');
      } else if (gtrackToken == null) {
        throw Exception('Gtrack token not found in response');
      }

      // Save access token
      await AppPreferences.setAccessToken(accessToken);
      await AppPreferences.setGTrackToken(gtrackToken);

      // Parse driver data
      final Driver driver = Driver.fromJson(data['driver']);

      // Save driver data to SharedPreferences
      await AppPreferences.saveDriver(driver);

      return driver;
    }
    return null;
  }

  Future<Driver?> loginWithNfc(String nfcNumber) async {
    final path = '/api/v1/drivers/login?nfcLogin=$nfcNumber';

    final response = await _httpService.request(
      path,
      method: HttpMethod.post,
      payload: {'nfcNumber': nfcNumber},
    );

    if (response.success) {
      final data = response.data['data'];

      // Extract tokens from response
      final accessToken = data['accessToken'];
      final gtrackToken = data['driver']['member']['token'];

      if (accessToken == null) {
        throw Exception('Access token not found in response');
      } else if (gtrackToken == null) {
        throw Exception('Gtrack token not found in response');
      }

      // Save access token
      await AppPreferences.setAccessToken(accessToken);
      await AppPreferences.setGTrackToken(gtrackToken);

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

  Future<String> verifyEmail(String email) async {
    final path = '/api/v1/drivers/verify-email';

    final response = await _httpService.request(
      path,
      method: HttpMethod.post,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      payload: {'email': email},
    );

    final data = response.data['data'];

    if (response.success) {
      return data['token'];
    }
    throw Exception('Email verification failed');
  }

  Future<void> verifyOtp(String otp, String token) async {
    final path = '/api/v1/drivers/verify-otp';

    final response = await _httpService.request(
      path,
      method: HttpMethod.post,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      payload: {'otp': otp, 'token': token},
    );

    if (response.success) {
      return;
    }

    throw Exception('OTP verification failed');
  }

  Future<void> enableAndDisableNFC(
    String status,
    bool isNFCEnabled,
    String nfcNumber,
  ) async {
    final path = '/api/v1/drivers/update-by-mobile';

    final token = await AppPreferences.getAccessToken();

    final res = await _httpService.request(
      path,
      method: HttpMethod.put,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      payload:
          status == 'enable'
              ? {'nfcNumber': nfcNumber, 'isNFCEnabled': isNFCEnabled}
              : {'isNFCEnabled': isNFCEnabled},
    );

    if (res.success) {
      return;
    }
    throw Exception('NFC update failed');
  }

  Future<void> resetPassword(
    String newPassword,
    String email,
    String token,
  ) async {
    final path = '/api/v1/drivers/reset-password';

    final response = await _httpService.request(
      path,
      method: HttpMethod.patch,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      payload: {'password': newPassword, 'email': email},
    );

    if (response.success) {
      return;
    }
    throw Exception('Password reset failed');
  }

  Future<ViewAssignedRouteModel> fetchViewAssignedRoute() async {
    final path = '/api/v1/routes/driver';

    final token = await AppPreferences.getAccessToken();

    final response = await _httpService.request(
      path,
      method: HttpMethod.get,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.success) {
      return ViewAssignedRouteModel.fromJson(response.data['data']);
    }
    throw Exception('Failed to fetch assigned route');
  }
}
// This method is currently a placeholder and should be implemented based on your requirements.