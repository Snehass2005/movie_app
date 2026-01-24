import '../../../../core/exceptions/http_exception.dart';
import '../../../../core/network/model/either.dart';
import '../../data/models/movie_list_dto.dart';
import '../entities/movie.dart';

/// Contract for movie list repository
abstract class MovieListRepository {
  Future<Either<AppException, List<Movie>>> searchMovies({
    required String query,
    int page,
  });
}