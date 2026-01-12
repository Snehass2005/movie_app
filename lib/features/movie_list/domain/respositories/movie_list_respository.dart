import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import '../entities/movie.dart';

abstract class MovieListRepository {
  Future<Either<AppException, List<Movie>>> searchMovies(String query, {int page});
}