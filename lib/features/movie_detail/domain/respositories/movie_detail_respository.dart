import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_detail/data/models/movie_detail_dto.dart';

/// Domain repository interface for fetching movie details.
/// Only supports getMovieDetail.
abstract class MovieDetailRepository {
  Future<Either<AppException, MovieDetailDto>> getMovieDetail(String imdbID);
}