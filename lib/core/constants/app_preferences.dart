import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  // Private constructor to prevent instantiation
  AppPreferences._();

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyGTrackToken = 'gtrack_token';

  // Access Token methods
  static Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, token);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  static Future<void> removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
  }

  // GTrack Token methods
  static Future<void> setGTrackToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGTrackToken, token);
  }

  static Future<String?> getGTrackToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGTrackToken);
  }

  static Future<void> removeGTrackToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyGTrackToken);
  }

  // Helper to clear all tokens (for logout)
  static Future<void> clearAllTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyGTrackToken);
  }
}
