import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class DeliveryDetailsRepository {
  Future<String> uploadSignature(File images, String salesOrderId) async {
    String? deliveryId = await AppPreferences.getDeliveryId(
      salesOrderId: salesOrderId,
    );

    deliveryId = deliveryId.toString().replaceAll(salesOrderId, "");

    log(deliveryId.toString());

    if (images.path.isEmpty) {
      print("No image to upload");
      return "No image to upload";
    }

    var url = Uri.parse(
      "${kGrouteUrl}/api/v1/delivery-details/upload-signature/$deliveryId",
    );

    final token = await AppPreferences.getAccessToken();

    // headers
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    var request = http.MultipartRequest('PATCH', url);

    File resizedImage = images;

    var mimeType = getMediaType(resizedImage.path);

    var multipartFile = await http.MultipartFile.fromPath(
      'signature',
      resizedImage.path,
      contentType: mimeType,
      filename: resizedImage.path.split('/').last,
    );

    request.files.add(multipartFile);

    request.headers.addAll(headers);

    var response = await request.send();

    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Image uploaded successfully';
    } else {
      var msg = jsonDecode(responseBody.body);
      throw Exception(
        msg['message'] ?? msg['error'] ?? 'Failed to upload image',
      );
    }
  }

  Future<void> uploadImages(List<File> images, String salesOrderId) async {
    String? deliveryId = await AppPreferences.getDeliveryId(
      salesOrderId: salesOrderId,
    );

    deliveryId = deliveryId.toString().replaceAll(salesOrderId, "");

    if (images.isEmpty) {
      print("No images to upload");
      return;
    }
    try {
      var url = Uri.parse(
        "${kGrouteUrl}/api/v1/delivery-details/upload-images/$deliveryId",
      );

      final token = await AppPreferences.getAccessToken();

      // Create multipart request
      var request = http.MultipartRequest('PATCH', url);

      // Set authorization header only (don't set Content-Type manually)
      request.headers['Authorization'] = 'Bearer $token';

      // Add each image to the request
      for (var image in images) {
        try {
          var mimeType = getMediaType(image.path);
          var fileName = image.path.split('/').last;

          var multipartFile = await http.MultipartFile.fromPath(
            'images',
            image.path,
            contentType: mimeType,
            filename: fileName,
          );

          request.files.add(multipartFile);
          print('Image added: $fileName');
        } catch (e) {
          print("Error processing image: $e");
          throw Exception("Failed to process image: ${e.toString()}");
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

      // Check if successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Images uploaded successfully');
      } else {
        // Parse error response
        Map<String, dynamic> errorData = {};
        try {
          errorData = jsonDecode(response.body);
        } catch (_) {
          // If JSON parsing fails, use empty map
        }

        final errorMessage =
            errorData['message'] ??
            errorData['error'] ??
            'Failed to upload images (Status: ${response.statusCode})';

        print('Upload failed: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print("Exception during image upload: $e");
      throw Exception("Failed to upload images: ${e.toString()}");
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
