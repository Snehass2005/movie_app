import 'package:movie_app/core/exceptions/http_exception.dart';
import 'model/either.dart';
import 'model/response.dart';

/// NetworkService
///
/// Abstract interface for all network services.
/// Enforces strict rules for GET, POST, PUT, DELETE.
/// Makes it easy to swap implementations (Dio, Http, Fake).
abstract class NetworkService {
  String get baseUrl;
  Map<String, Object> get headers;

  /// Update headers (e.g., add Auth token)
  void updateHeader(Map<String, dynamic> data);

  Future<Either<AppException, Response>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      });

  Future<Either<AppException, Response>> post(
      String endpoint, {
        Map<String, dynamic>? data,
      });

  Future<Either<AppException, Response>> put(
      String endpoint, {
        Map<String, dynamic>? data,
      });

  Future<Either<AppException, Response>> delete(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      });
}