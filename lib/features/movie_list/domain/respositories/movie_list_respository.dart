import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import '../../data/models/movie_list_dto.dart';

/// Domain repository interface for fetching movie lists.
/// Only supports searchMovies.
abstract class MovieListRepository {
  Future<Either<AppException, List<MovieListDto>>> searchMovies(String query);
}