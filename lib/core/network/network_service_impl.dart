import 'package:movie_app/core/network/api_client.dart';
import 'package:movie_app/core/network/connection/connection_listener.dart';

class NetworkServiceImpl {
  final ApiClient apiClient;
  final ConnectionStatusListener connectionListener;

  NetworkServiceImpl({
    required this.apiClient,
    required this.connectionListener,
  });

  Future<Map<String, dynamic>> safeGet(Map<String, String> query) async {
    // ✅ Use checkConnection() instead of isConnected()
    final connected = await connectionListener.checkConnection();
    if (!connected) {
      throw Exception('No internet connection');
    }

    return await apiClient.get(query);
  }
}