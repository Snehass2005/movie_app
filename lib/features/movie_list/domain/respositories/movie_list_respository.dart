import 'package:movie_app/core/exceptions/http_exception.dart';
import '../../../../core/network/model/either.dart';
import '../../data/models/MovieListDto.dart';

abstract class MovieListRepository {
  Future<Either<AppException, List<MovieListDto>>> searchMovies({
    required String query,
    int page,
  });
}