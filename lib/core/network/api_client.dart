import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/http_exception.dart'; // contains AppException


class ApiClient {
  final String baseUrl;
  final String apiKey;
  final http.Client _client;

  ApiClient({
    required this.baseUrl,
    required this.apiKey,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String path, Map<String, String> query) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: {
        'apikey': apiKey, // ✅ always include API key
        ...query,
      },
    );

    final res = await _client.get(uri);

    if (res.statusCode != 200) {
      throw AppException(
        message: 'Network error',
        statusCode: res.statusCode,
        identifier: uri.toString(),
      );
    }

    try {
      final data = json.decode(res.body) as Map<String, dynamic>;

      if (data['Response'] == 'False') {
        throw AppException(
          message: data['Error'] ?? 'Unknown API error',
          statusCode: 400,
          identifier: uri.toString(),
        );
      }

      return data;
    } catch (e) {
      throw AppException(
        message: 'Failed to parse response',
        statusCode: res.statusCode,
        identifier: uri.toString(),
      );
    }
  }
}