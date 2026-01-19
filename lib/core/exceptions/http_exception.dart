import 'package:movie_app/core/network/model/either.dart';
import 'package:equatable/equatable.dart';

import '../network/model/response.dart';

/// Base application exception class
class AppException implements Exception {
  final String message;
  final int statusCode;
  final String identifier;

  /// General constructor
  AppException({
    required this.message,
    required this.statusCode,
    required this.identifier,
  });

  /// Named constructor for network errors
  AppException.network(String message)
      : message = 'Network Error: $message',
        statusCode = -1,
        identifier = 'network';

  /// Named constructor for server errors
  AppException.server(int code, String message)
      : message = message,
        statusCode = code,
        identifier = 'server';

  /// Named constructor for unauthorized errors
  AppException.unauthorized(String message)
      : message = message,
        statusCode = 401,
        identifier = 'unauthorized';

  @override
  String toString() {
    return 'statusCode=$statusCode\nmessage=$message\nidentifier=$identifier';
  }
}

/// Example of a custom exception (you can add more as needed)
class CacheFailureException extends AppException with EquatableMixin {
  CacheFailureException()
      : super(
    message: 'Unable to save movie data',
    statusCode: 100,
    identifier: 'Cache failure exception',
  );

  @override
  List<Object?> get props => [message, statusCode, identifier];
}

/// Extension to easily convert exceptions into Either.Left
extension HttpExceptionExtension on AppException {
  Left<AppException, Response> get toLeft =>
      Left<AppException, Response>(this);
}