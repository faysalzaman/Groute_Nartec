// import 'package:shared_preferences/shared_preferences.dart';

// class AppPreferences {
//   static const String _keyToken = 'token';
//   static const String _keyUserId = 'user_id';
//   static const String _keyName = 'name';
//   static const String _keyEmail = 'email';
//   static const String _keyPhone = 'phone';
//   static const String _keyHasNfc = 'has_nfc';
//   static const String _keyHasFingerprint = 'has_fingerprint';
//   static const String _keyNFCRegistered = 'nfc_registered';
//   static const String _keyFingerprintRegistered = 'fingerprint_registered';
//   static const String _keyCurrentBalance = 'currentBalance';

//   static late SharedPreferences _preferences;

//   // Initialize shared preferences
//   static Future<void> init() async {
//     _preferences = await SharedPreferences.getInstance();
//   }

//   // Individual setters (replacing setUserData)
//   static Future<bool> setUserId(String? id) async {
//     return await _preferences.setString(_keyUserId, id ?? '');
//   }

//   static Future<bool> setName(String? name) async {
//     return await _preferences.setString(_keyName, name ?? '');
//   }

//   static Future<bool> setEmail(String? email) async {
//     return await _preferences.setString(_keyEmail, email ?? '');
//   }

//   static Future<bool> setPhone(String? phone) async {
//     return await _preferences.setString(_keyPhone, phone ?? '');
//   }

//   static Future<bool> setToken(String? token) async {
//     return await _preferences.setString(_keyToken, token ?? '');
//   }

//   static Future<bool> setHasNfc(bool? hasNfc) async {
//     return await _preferences.setBool(_keyHasNfc, hasNfc ?? false);
//   }

//   static Future<bool> setHasFingerprint(bool? hasFingerprint) async {
//     return await _preferences.setBool(
//       _keyHasFingerprint,
//       hasFingerprint ?? false,
//     );
//   }

//   static Future<bool> setCurrentBalance(num? currentBalance) async {
//     return await _preferences.setDouble(
//       _keyCurrentBalance,
//       currentBalance?.toDouble() ?? 0,
//     );
//   }

//   // Individual getters
//   static String? getUserId() => _preferences.getString(_keyUserId);
//   static String? getName() => _preferences.getString(_keyName);
//   static String? getEmail() => _preferences.getString(_keyEmail);
//   static String? getPhone() => _preferences.getString(_keyPhone);
//   static String? getToken() => _preferences.getString(_keyToken);
//   static bool? getHasNfc() => _preferences.getBool(_keyHasNfc);
//   static bool? getHasFingerprint() => _preferences.getBool(_keyHasFingerprint);
//   static num? getCurrentBalance() => _preferences.getDouble(_keyCurrentBalance);

//   // Clear all user data
//   static Future<bool> clearUserData() async {
//     await _preferences.remove(_keyUserId);
//     await _preferences.remove(_keyName);
//     await _preferences.remove(_keyPhone);
//     await _preferences.remove(_keyCurrentBalance);
//     return true;
//   }

//   // Get NFC registration status
//   static Future<bool?> getNFCRegistered() async {
//     return _preferences.getBool(_keyNFCRegistered);
//   }

//   // Set NFC registration status
//   static Future<void> setNFCRegistered(bool value) async {
//     await _preferences.setBool(_keyNFCRegistered, value);
//   }

//   // Get Fingerprint registration status
//   static Future<bool?> getFingerprintRegistered() async {
//     return _preferences.getBool(_keyFingerprintRegistered);
//   }

//   // Set Fingerprint registration status
//   static Future<void> setFingerprintRegistered(bool value) async {
//     await _preferences.setBool(_keyFingerprintRegistered, value);
//   }

//   static Future<void> logout() async {
//     await clearUserData();
//   }
// }
