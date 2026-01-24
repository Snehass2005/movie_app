import '../../../../core/exceptions/http_exception.dart';
import '../../../../core/network/model/either.dart';
import '../entities/movie.dart';
import '../respositories/movie_list_respository.dart';

/// Use case layer for searching movies.
/// Matches the MovieListRepository interface and returns Domain Entities.

class SearchMoviesUseCase {
  final MovieListRepository _repository;

  const SearchMoviesUseCase(this._repository);

  Future<Either<AppException, List<Movie>>> call({
    required String query,
    int page = 1,
  }) async {
    return await _repository.searchMovies(query: query, page: page);
  }
}