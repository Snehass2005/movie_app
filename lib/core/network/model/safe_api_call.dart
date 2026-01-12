import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';

/// Wraps any async API call in Either<AppException, T>.
Future<Either<AppException, T>> safeApiCall<T>(
    Future<T> Function() call, {
      String identifier = '',
    }) async {
  try {
    final result = await call();
    return Right(result);
  } on AppException catch (e) {
    return Left(e);
  } catch (e) {
    return Left(
      AppException(
        message: 'Unexpected error',
        statusCode: 1,
        identifier: '$identifier\n${e.toString()}',
      ),
    );
  }
}