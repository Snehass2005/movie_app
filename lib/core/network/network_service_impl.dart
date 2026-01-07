

import 'package:movie_app/core/network/api_client.dart';
import 'package:movie_app/core/network/connection/connection_listener.dart';

class NetworkServiceImpl {
  final ApiClient apiClient;
  final ConnectionStatusListener connectionListener;

  NetworkServiceImpl({
    required this.apiClient,
    required this.connectionListener,
  });

  Future<Map<String, dynamic>> safeGet(String path, Map<String, String> query) async {
    // You can add retry, caching, or offline fallback here
    return await apiClient.get(path, query);
  }
}