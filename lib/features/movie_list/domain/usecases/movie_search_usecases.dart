import 'package:movie_app/features/movie_list/data/models/MovieListDto.dart';

import '../../../../core/exceptions/http_exception.dart';
import '../../../../core/network/model/either.dart';
import '../respositories/movie_list_respository.dart';

/// Use case layer for searching movies.
/// Matches the MovieListRepository interface and returns Domain Entities.

class SearchMoviesUseCase {
  final MovieListRepository _repository;

  const SearchMoviesUseCase(this._repository);

  Future<Either<AppException, List<MovieListDto>>> call({
    required String query,
    int page = 1,
  }) async {
    return await _repository.searchMovies(query: query, page: page);
  }
}