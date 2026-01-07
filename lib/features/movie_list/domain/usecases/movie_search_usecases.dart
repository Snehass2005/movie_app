import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_list/domain/respositories/movie_list_respository.dart';
import '../../data/models/movie_list_dto.dart';

/// Use case layer for searching movies.
/// Matches the simplified MovieListRepository interface.
class SearchMoviesUseCase {
  final MovieListRepository _repository;

  const SearchMoviesUseCase(this._repository);

  Future<Either<AppException, List<MovieListDto>>> call(String query) async {
    return _repository.searchMovies(query);
  }
}