import 'package:http/http.dart' as http;

class ApiInterceptor extends http.BaseClient {
  final http.Client _inner;

  ApiInterceptor(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    print('➡️ Request: ${request.method} ${request.url}');
    return _inner.send(request).then((response) {
      print('⬅️ Response: ${response.statusCode} ${request.url}');
      return response;
    });
  }
}