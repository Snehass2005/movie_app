import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_detail/domain/respositories/movie_detail_respository.dart';
import 'package:movie_app/features/movie_detail/data/models/movie_detail_dto.dart';

/// Use case layer for fetching movie details.
/// Matches the simplified MovieDetailRepository interface.
class GetMovieDetailUseCase {
  final MovieDetailRepository _repository;

  const GetMovieDetailUseCase(this._repository);

  Future<Either<AppException, MovieDetailDto>> call(String imdbID) async {
    return _repository.getMovieDetail(imdbID);
  }
}