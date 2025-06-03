import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/customer_profile.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class SalesOrderRepository {
  final HttpService _httpService = HttpService();

  FutureOr<void> updateSalesInvoiceDetail(String id) async {
    final path = '/api/v1/sales-orders/update-sales-invoice-details';

    final response = await _httpService.request(
      path,
      method: HttpMethod.put,
      payload: {'id': id, 'deliveryDate': DateTime.now().toIso8601String()},
    );

    if (!response.success) {
      throw Exception('Failed to update sales order status');
    }
  }

  Future<List<SalesOrderModel>> getSalesOrders(
    int page,
    int limit, {
    String? status,
  }) async {
    final token = await AppPreferences.getAccessToken();
    String path = '/api/v1/sales-orders/driver?page=$page&limit=$limit';
    if (status != null) {
      path += "&status=$status";
    }

    final response = await _httpService.request(
      path,
      method: HttpMethod.get,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.success) {
      final data = response.data['data']['salesOrders'] as List;
      return data.map((order) => SalesOrderModel.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load sales orders');
    }
  }

  // update sales order status
  Future<void> updateStatus(String id, Map<String, dynamic> body) async {
    final token = await AppPreferences.getAccessToken();

    final path = '/api/v1/sales-orders/$id';

    final response = await _httpService.request(
      path,
      method: HttpMethod.put,
      payload: body,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (!response.success) {
      throw Exception('Failed to update sales order status');
    }
  }

  Future<List<SalesInvoiceDetails>> getSalesDetailsBySalesOrderId(
    String id,
  ) async {
    final token = await AppPreferences.getAccessToken();

    final path = '/api/v1/sales-orders/sales-invoice-details/$id';

    final response = await _httpService.request(
      path,
      method: HttpMethod.get,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.success) {
      final data = response.data['data'] as List;
      return data
          .map((detail) => SalesInvoiceDetails.fromJson(detail))
          .toList();
    } else {
      throw Exception('Failed to load sales order');
    }
  }

  Future<List<CustomerProfileModel>> getCustomerProfile() async {
    final token = await AppPreferences.getAccessToken();

    final path = '/api/v1/customers/driver';

    final response = await _httpService.request(
      path,
      method: HttpMethod.get,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.success) {
      final data = response.data['data'] as List;
      return data
          .map((profile) => CustomerProfileModel.fromJson(profile))
          .toList();
    } else {
      throw Exception('Failed to load customer profile');
    }
  }

  Future<String> uploadSignature(File images, String id) async {
    var url = Uri.parse("${kGrouteUrl}/api/v1/sales-orders/add-signature/$id");

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

  Future<void> uploadImages(
    List<File> images,
    String orderId,
    String productId,
  ) async {
    try {
      var url = Uri.parse(
        "${kGrouteUrl}/api/v1/sales-orders/add-images/$orderId/product/$productId",
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
