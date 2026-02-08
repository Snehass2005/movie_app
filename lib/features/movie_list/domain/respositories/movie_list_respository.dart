import 'package:movie_app/core/exceptions/http_exception.dart';
import '../../../../core/network/model/either.dart';
import '../../data/models/MovieListModel.dart';

abstract class MovieListRepository {
  Future<Either<AppException, List<MovieListModel>>> searchMovies({
    required String query,
    int page,
    String? year,
  });
}