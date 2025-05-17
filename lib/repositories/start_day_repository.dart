import 'dart:convert';
import 'dart:io';

import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/vehicle_check_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class StartDayRepository {
  final HttpService _httpService = HttpService();

  Future<VehicleCheckModel> getVehicleCheckHistory() async {
    final token = await AppPreferences.getAccessToken();
    final path = 'v1/vehicles/driver/last-check';

    final response = await _httpService.request(
      path,
      method: HttpMethod.get,
      headers: {'Authorization': 'Bearer $token'},
    );

    var data = response.data['data'];

    if (response.success) {
      final getData = data['lastVehicleCheck'] as Map<String, dynamic>;
      if (getData.isEmpty) {
        throw Exception('No vehicle check history found');
      }
      return VehicleCheckModel.fromJson(data);
    } else {
      var msg =
          data['message'] ??
          data['error'] ??
          'Failed to load vehicle check history';
      throw Exception(msg);
    }
  }

  Future<String> uploadPhotoAndSubmitDriverCondition(
    List<File> photos,
    String vehicleId,
    String tyresCondition,
    String aCCondition,
    String petrolLevel,
    String engineCondition,
    String odoMeterReading,
    String remarks,
  ) async {
    try {
      var url = Uri.parse("${kGrouteUrl}v1/vehicles/check");

      final token = await AppPreferences.getAccessToken();

      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add all the driver condition fields to the request
      request.fields['vehicleId'] = vehicleId;
      request.fields['tyresCondition'] = tyresCondition;
      request.fields['ACCondition'] = aCCondition;
      request.fields['petrolLevel'] = petrolLevel;
      request.fields['engineCondition'] = engineCondition;
      request.fields['odoMeterReading'] = odoMeterReading;
      request.fields['remarks'] = remarks;

      // Add each photo to the request
      for (var photo in photos) {
        try {
          var mimeType = getMediaType(photo.path);
          var fileName = photo.path.split('/').last;

          var multipartFile = await http.MultipartFile.fromPath(
            'photos', // Changed from 'photo' to 'photos' for multiple files
            photo.path,
            contentType: mimeType,
            filename: fileName,
          );

          request.files.add(multipartFile);
        } catch (e) {
          print("Error processing photo: $e");
          throw Exception("Failed to process photo: ${e.toString()}");
        }
      }

      // Send the request
      var streamedResponse = await request.send().timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          throw Exception("Request timed out. Please check your connection.");
        },
      );

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'Photos uploaded successfully';
      } else {
        var msg = jsonDecode(response.body);
        throw Exception(
          msg['message'] ?? msg['error'] ?? 'Failed to upload photos',
        );
      }
    } catch (e) {
      print("Exception during photo upload: $e");
      throw Exception("Failed to upload photos: ${e.toString()}");
    }
  }

  /// Helper function to get MIME type from file extension
  MediaType getMediaType(String path) {
    final mimeType = lookupMimeType(path);
    if (mimeType != null) {
      final parts = mimeType.split('/');
      if (parts.length == 2) {
        return MediaType(parts[0], parts[1]);
      }
    }
    return MediaType('application', 'octet-stream');
  }
}
