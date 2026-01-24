import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_detail/domain/entities/movie_detail.dart';

/// Domain repository interface for fetching movie details.
/// Exposes [MovieDetail] entity instead of DTO.
abstract class MovieDetailRepository {
  Future<Either<AppException, MovieDetail>> getMovieDetail({
    required String imdbID,
  });
}