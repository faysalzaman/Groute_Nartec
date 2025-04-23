import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/view/screens/auth/model/child_member.dart';

class AuthController {
  final HttpService _httpService = HttpService();

  Future<ChildMember?> login(String email, String password) async {
    final path = 'v1/child-members/login';

    final response = await _httpService.request(
      path,
      method: HttpMethod.post,
      payload: {'email': email, 'password': password},
    );

    if (response.success) {
      final data = response.data['data'];

      // Extract tokens from response
      final accessToken = data['accessToken'];
      final gtrackToken = data['GTrackResponse']['token'];

      if (accessToken == null) {
        throw Exception('Access token not found in response');
      } else if (gtrackToken == null) {
        throw Exception('GTrack token not found in response');
      }

      final ChildMember childMember = ChildMember.fromJson(
        data['GTrackResponse']['subUser'],
      );

      // Save tokens to SharedPreferences
      await AppPreferences.setAccessToken(accessToken);
      if (gtrackToken != null) {
        await AppPreferences.setGTrackToken(gtrackToken);
      }

      return childMember;
    }
    return null;
  }
}
