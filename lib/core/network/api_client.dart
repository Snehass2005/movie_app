import 'package:dio/dio.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/main/app_env.dart';
class ApiClient {
  final Dio _dio;
  final String apiKey;

  ApiClient({
    required this.apiKey,
  }) : _dio = Dio(
    BaseOptions(
      baseUrl: EnvInfo.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Future<Map<String, dynamic>> get(Map<String, String> queryParams) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          'apikey': apiKey,
          ...queryParams,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        if (data['Response'] == 'False') {
          throw AppException(
            message: data['Error'] ?? 'Unknown API error',
            statusCode: 400,
            identifier: 'ApiClient.get',
          );
        }

        return data;
      } else {
        throw AppException(
          message: 'Network error',
          statusCode: response.statusCode ?? -1,
          identifier: 'ApiClient.get',
        );
      }
    } on DioException catch (e) {
      throw AppException(
        message: e.message ?? 'Unexpected Dio error',
        statusCode: e.response?.statusCode ?? -1,
        identifier: 'ApiClient.get',
      );
    } catch (e) {
      throw AppException(
        message: 'Unexpected error',
        statusCode: -1,
        identifier: 'ApiClient.get\n${e.toString()}',
      );
    }
  }
}