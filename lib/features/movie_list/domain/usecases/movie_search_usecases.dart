import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_list/domain/entities/movie.dart';
import 'package:movie_app/features/movie_list/domain/respositories/movie_list_respository.dart';

/// Use case layer for searching movies.
/// Matches the MovieListRepository interface and returns Domain Entities.
class SearchMoviesUseCase {
  final MovieListRepository _repository;

  const SearchMoviesUseCase(this._repository);

  Future<Either<AppException, List<Movie>>> call(String query, {int page = 1}) async {
    return _repository.searchMovies(query, page: page);
  }
}