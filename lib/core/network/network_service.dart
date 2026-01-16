import 'package:movie_app/core/exceptions/http_exception.dart';

import 'model/either.dart';

/// NetworkServiceImpl
///
/// This class wraps a concrete [NetworkService] implementation (e.g. DioNetworkService).
/// It enforces the contract and provides a single entry point for repositories.
class NetworkServiceImpl {
  final NetworkService _service;

  NetworkServiceImpl(this._service);

  Future<Either<AppException, Response>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      }) {
    return _service.get(endpoint, queryParameters: queryParameters);
  }

  Future<Either<AppException, Response>> post(
      String endpoint, {
        Map<String, dynamic>? data,
      }) {
    return _service.post(endpoint, data: data);
  }

  Future<Either<AppException, Response>> put(
      String endpoint, {
        Map<String, dynamic>? data,
      }) {
    return _service.put(endpoint, data: data);
  }

  Future<Either<AppException, Response>> delete(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      }) {
    return _service.delete(endpoint, queryParameters: queryParameters);
  }
}