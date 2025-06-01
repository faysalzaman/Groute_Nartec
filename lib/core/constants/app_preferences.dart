import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/modules/auth/models/driver_model.dart';

class AppPreferences {
  // Private constructor to prevent instantiation
  AppPreferences._();

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyDriverData = 'driver_data';
  static const String _keyDriverId = 'driver_id';
  static const String _keyDriverName = 'driver_name';
  static const String _keyDriverNameAr = 'driver_name_ar';
  static const String _keyDriverNameNl = 'driver_name_nl';
  static const String _keyDriverEmail = 'driver_email';
  static const String _keyDriverIdNumber = 'driver_id_number';
  static const String _keyDriverPhone = 'driver_phone';
  static const String _keyDriverLicense = 'driver_license';
  static const String _keyDriverExperience = 'driver_experience';
  static const String _keyDriverAvailability = 'driver_availability';
  static const String _keyDriverPhoto = 'driver_photo';
  static const String _keyDriverIsNFCEnabled = 'driver_is_nfc_enabled';
  static const String _keyDriverNFCNumber = 'driver_nfc_number';
  static const String _keyDriverCreatedAt = 'driver_created_at';
  static const String _keyDriverUpdatedAt = 'driver_updated_at';
  static const String _keyDriverMemberId = 'driver_member_id';
  static const String _keyDriverVehicleId = 'driver_vehicle_id';
  static const String _keyDriverRouteId = 'driver_route_id';
  static const String _keyGTrackToken = 'gtrack_token';
  static const String _keyRememberMe = 'remember_me';

  static const String _deliveryId = 'deliveryId';

  // setter for deliveryId
  static Future<void> setDeliveryId(String deliveryId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deliveryId, deliveryId);
  }

  // getter for deliveryId
  static Future<String?> getDeliveryId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deliveryId);
  }

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

  // Driver data methods - Save entire driver object
  static Future<void> saveDriver(Driver driver) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDriverData, jsonEncode(driver.toJson()));

    // Also save individual fields for easier access
    await prefs.setString(_keyDriverId, driver.id ?? '');
    await prefs.setString(_keyDriverName, driver.name ?? '');
    await prefs.setString(_keyDriverNameAr, driver.nameAr ?? '');
    await prefs.setString(_keyDriverNameNl, driver.nameNl ?? '');
    await prefs.setString(_keyDriverEmail, driver.email ?? '');
    await prefs.setString(_keyDriverIdNumber, driver.idNumber ?? '');
    await prefs.setString(_keyDriverPhone, driver.phone ?? '');
    await prefs.setString(_keyDriverLicense, driver.license ?? '');
    await prefs.setString(_keyDriverExperience, driver.experience ?? '');
    await prefs.setString(_keyDriverAvailability, driver.availability ?? '');
    await prefs.setString(_keyDriverPhoto, driver.photo ?? '');
    await prefs.setBool(_keyDriverIsNFCEnabled, driver.isNFCEnabled ?? false);
    await prefs.setString(_keyDriverNFCNumber, driver.nfcNumber ?? '');
    await prefs.setString(_keyDriverCreatedAt, driver.createdAt ?? '');
    await prefs.setString(_keyDriverUpdatedAt, driver.updatedAt ?? '');
    await prefs.setString(_keyDriverMemberId, driver.memberId ?? '');
    await prefs.setString(_keyDriverVehicleId, driver.vehicleId ?? '');
    await prefs.setString(_keyDriverRouteId, driver.routeId ?? '');
  }

  // Get the entire driver object
  static Future<Driver?> getDriver() async {
    final prefs = await SharedPreferences.getInstance();
    final driverJson = prefs.getString(_keyDriverData);
    if (driverJson == null) return null;

    try {
      return Driver.fromJson(jsonDecode(driverJson));
    } catch (e) {
      return null;
    }
  }

  // Individual getters for driver fields
  static Future<String?> getDriverId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverId);
  }

  static Future<String?> getDriverName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverName);
  }

  static Future<String?> getDriverNameAr() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverNameAr);
  }

  static Future<String?> getDriverNameNl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverNameNl);
  }

  static Future<String?> getDriverEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverEmail);
  }

  static Future<String?> getDriverIdNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverIdNumber);
  }

  static Future<String?> getDriverPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverPhone);
  }

  static Future<String?> getDriverLicense() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverLicense);
  }

  static Future<String?> getDriverExperience() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverExperience);
  }

  static Future<String?> getDriverAvailability() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverAvailability);
  }

  static Future<String?> getDriverPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverPhoto);
  }

  static Future<bool?> getDriverIsNFCEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDriverIsNFCEnabled);
  }

  static Future<String?> getDriverNFCNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverNFCNumber);
  }

  static Future<String?> getDriverCreatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverCreatedAt);
  }

  static Future<String?> getDriverUpdatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverUpdatedAt);
  }

  static Future<String?> getDriverMemberId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverMemberId);
  }

  static Future<String?> getDriverVehicleId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverVehicleId);
  }

  static Future<String?> getDriverRouteId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverRouteId);
  }

  // Clear driver data
  static Future<void> clearDriverData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDriverData);
    await prefs.remove(_keyDriverId);
    await prefs.remove(_keyDriverName);
    await prefs.remove(_keyDriverNameAr);
    await prefs.remove(_keyDriverNameNl);
    await prefs.remove(_keyDriverEmail);
    await prefs.remove(_keyDriverIdNumber);
    await prefs.remove(_keyDriverPhone);
    await prefs.remove(_keyDriverLicense);
    await prefs.remove(_keyDriverExperience);
    await prefs.remove(_keyDriverAvailability);
    await prefs.remove(_keyDriverPhoto);
    await prefs.remove(_keyDriverCreatedAt);
    await prefs.remove(_keyDriverUpdatedAt);
    await prefs.remove(_keyDriverMemberId);
    await prefs.remove(_keyDriverVehicleId);
    await prefs.remove(_keyDriverRouteId);
  }

  // Remember Me methods
  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, value);
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  // Helper to clear all data (for logout)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRememberMe);
    await clearDriverData();
  }

  // Add these new methods to update NFC settings

  // Set NFC enabled status
  static Future<void> setDriverIsNFCEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDriverIsNFCEnabled, enabled);
  }

  // Set NFC card number
  static Future<void> setDriverNFCNumber(String nfcNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDriverNFCNumber, nfcNumber);
  }

  // Toggle NFC enabled status and return the new value
  static Future<bool> toggleNFCEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final currentValue = prefs.getBool(_keyDriverIsNFCEnabled) ?? false;
    final newValue = !currentValue;
    await prefs.setBool(_keyDriverIsNFCEnabled, newValue);
    return newValue;
  }
}
