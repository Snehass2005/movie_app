import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_detail/data/models/MovieDetailModel.dart';

/// Domain repository interface for fetching movie details.
/// Exposes [MovieDetail] entity instead of DTO.
abstract class MovieDetailRepository {
  Future<Either<AppException, MovieDetailModel>> getMovieDetail({
    required String imdbID,
  });
}