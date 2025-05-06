import 'dart:convert';
import 'dart:io';

import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class StartDayRepository {
  final HttpService _httpService = HttpService();

  Future<String> uploadPhotoAndSubmitDriverCondition(
    File photo,
    String vehicleId,
    String tyresCondition,
    String aCCondition,
    String petrolLevel,
    String engineCondition,
    String odoMeterReading,
  ) async {
    var url = Uri.parse("${kGrouteUrl}v1/vehicles/check");

    final token = await AppPreferences.getAccessToken();

    // headers
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    var request = http.MultipartRequest('POST', url);

    // Add all the driver condition fields to the request
    request.fields['vehicleId'] = vehicleId;
    request.fields['tyresCondition'] = tyresCondition;
    request.fields['ACCondition'] = aCCondition;
    request.fields['petrolLevel'] = petrolLevel;
    request.fields['engineCondition'] = engineCondition;
    request.fields['odoMeterReading'] = odoMeterReading;

    File resizedImage = photo;

    var mimeType = getMediaType(resizedImage.path);

    var multipartFile = await http.MultipartFile.fromPath(
      'photo',
      resizedImage.path,
      contentType: mimeType,
      filename: resizedImage.path.split('/').last,
    );

    request.files.add(multipartFile);

    request.headers.addAll(headers);

    var response = await request.send();

    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Photo uploaded successfully';
    } else {
      var msg = jsonDecode(responseBody.body);
      throw Exception(
        msg['message'] ?? msg['error'] ?? 'Failed to upload photo',
      );
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
