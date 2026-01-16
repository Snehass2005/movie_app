import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:movie_app/core/exceptions/exception_handler_mixin.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/main/app_env.dart';

import 'model/either.dart';
import 'model/response.dart';


/// DioNetworkService
///
/// Concrete implementation of [NetworkService] using Dio.
/// Handles base URL, headers, logging, and error handling.
class DioNetworkService extends NetworkService with ExceptionHandlerMixin {
  late final Dio _dio;

  DioNetworkService() {
    _dio = Dio();
    _dio.options = dioBaseOptions;

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

    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (res, handler) => handler.next(res),
      ),
    );
  }

  /// Base Dio configuration
  BaseOptions get dioBaseOptions =>
      BaseOptions(baseUrl: baseUrl, headers: headers);

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
    return handleException(
          () => _dio.get(endpoint, queryParameters: queryParameters),
      endpoint: endpoint,
    ).then((res) => res.map((r) => Response.fromJson(r.data)));
  }

  @override
  Future<Either<AppException, Response>> post(
      String endpoint, {
        Map<String, dynamic>? data,
      }) async {
    return handleException(
          () => _dio.post(endpoint, data: data),
      endpoint: endpoint,
    ).then((res) => res.map((r) => Response.fromJson(r.data)));
  }

  @override
  Future<Either<AppException, Response>> put(
      String endpoint, {
        Map<String, dynamic>? data,
      }) async {
    return handleException(
          () => _dio.put(endpoint, data: data),
      endpoint: endpoint,
    ).then((res) => res.map((r) => Response.fromJson(r.data)));
  }

  @override
  Future<Either<AppException, Response>> delete(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      }) async {
    return handleException(
          () => _dio.delete(endpoint, queryParameters: queryParameters),
      endpoint: endpoint,
    ).then((res) => res.map((r) => Response.fromJson(r.data)));
  }

  /// Optional: Upload files using FormData
  Future<Either<AppException, Response>> uploadFile(
      String endpoint,
      FormData formData,
      ) async {
    return handleException(
          () => _dio.post(endpoint, data: formData),
      endpoint: endpoint,
    ).then((res) => res.map((r) => Response.fromJson(r.data)));
  }
}