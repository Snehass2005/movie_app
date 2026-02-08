import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/main/app_env.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';

import 'model/either.dart';
import 'model/response.dart';
import 'network_service.dart';

class DioNetworkService extends NetworkService {
  late final dio.Dio _dio;

  DioNetworkService() {
    _dio = dio.Dio();
    _dio.options = dioBaseOptions;

    // ✅ Automatically add apiKey to every request
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters.addAll({'apikey': EnvInfo.apiKey});
          return handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          queryParameters: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          showProcessingTime: true,
          canShowLog: kDebugMode,
        ),
      );
    }
  }

  dio.BaseOptions get dioBaseOptions => dio.BaseOptions(
    baseUrl: baseUrl,
    headers: headers,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  @override
  String get baseUrl => EnvInfo.baseUrl;

  @override
  Map<String, Object> get headers => {
    'accept': 'application/json',
    'content-type': 'application/json',
  };

  @override
  void updateHeader(Map<String, dynamic> data) {
    final updated = {...headers, ...data};
    _dio.options.headers = updated;
  }

  @override
  Future<Either<AppException, Response>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      final dio.Response res = await _dio.get(
        endpoint.isEmpty ? '' : endpoint,
        queryParameters: queryParameters,
      );
      return Right(Response(
        statusCode: res.statusCode ?? 0,
        statusMessage: res.statusMessage ?? '',
        data: res.data,
      ));
    } catch (e) {
      if (e is dio.DioError) {
        final msg = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['Error'] ?? e.message ?? 'Unknown error')
            : (e.message ?? 'Unknown error');
        return Left(AppException.network(msg));
      }
      return Left(AppException.network(e.toString()));
    }
  }

  @override
  Future<Either<AppException, Response>> post(
      String endpoint, {
        Map<String, dynamic>? data,
      }) async {
    try {
      final dio.Response res = await _dio.post(endpoint, data: data);
      return Right(Response(
        statusCode: res.statusCode ?? 0,
        statusMessage: res.statusMessage ?? '',
        data: res.data,
      ));
    } catch (e) {
      if (e is dio.DioError) {
        final msg = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['Error'] ?? e.message ?? 'Unknown error')
            : (e.message ?? 'Unknown error');
        return Left(AppException.network(msg));
      }
      return Left(AppException.network(e.toString()));
    }
  }

  @override
  Future<Either<AppException, Response>> put(
      String endpoint, {
        Map<String, dynamic>? data,
      }) async {
    try {
      final dio.Response res = await _dio.put(endpoint, data: data);
      return Right(Response(
        statusCode: res.statusCode ?? 0,
        statusMessage: res.statusMessage ?? '',
        data: res.data,
      ));
    } catch (e) {
      if (e is dio.DioError) {
        final msg = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['Error'] ?? e.message ?? 'Unknown error')
            : (e.message ?? 'Unknown error');
        return Left(AppException.network(msg));
      }
      return Left(AppException.network(e.toString()));
    }
  }

  @override
  Future<Either<AppException, Response>> delete(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      final dio.Response res =
      await _dio.delete(endpoint, queryParameters: queryParameters);
      return Right(Response(
        statusCode: res.statusCode ?? 0,
        statusMessage: res.statusMessage ?? '',
        data: res.data,
      ));
    } catch (e) {
      if (e is dio.DioError) {
        final msg = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['Error'] ?? e.message ?? 'Unknown error')
            : (e.message ?? 'Unknown error');
        return Left(AppException.network(msg));
      }
      return Left(AppException.network(e.toString()));
    }
  }

  Future<Either<AppException, Response>> uploadFile(
      String endpoint,
      dio.FormData formData,
      ) async {
    try {
      final dio.Response res = await _dio.post(endpoint, data: formData);
      return Right(Response(
        statusCode: res.statusCode ?? 0,
        statusMessage: res.statusMessage ?? '',
        data: res.data,
      ));
    } catch (e) {
      if (e is dio.DioError) {
        final msg = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['Error'] ?? e.message ?? 'Unknown error')
            : (e.message ?? 'Unknown error');
        return Left(AppException.network(msg));
      }
      return Left(AppException.network(e.toString()));
    }
  }
}