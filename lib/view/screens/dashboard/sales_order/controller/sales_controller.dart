import 'dart:convert';
import 'dart:io';

import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/models/sales_order.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class SalesController {
  final HttpService _httpService = HttpService();

  Future<List<SalesOrderModel>> getSalesOrders(int page, int limit) async {
    final token = await AppPreferences.getAccessToken();
    final path = 'v1/sales-orders/driver?page=$page&limit=$limit';

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

    final path = 'v1/sales-orders/$id';

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

  Future<String> uploadImage(File images, String id) async {
    var url = Uri.parse("${kGrouteUrl}v1/sales-orders/add-signature/$id");

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
