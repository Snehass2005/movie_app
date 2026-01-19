import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:movie_app/features/movie_detail/domain/respositories/movie_detail_respository.dart';

/// Use case layer for fetching movie details.
/// Exposes domain entity [MovieDetail] instead of DTO.
class GetMovieDetailUseCase {
  final MovieDetailRepository _repository;

  const GetMovieDetailUseCase(this._repository);

  Future<Either<AppException, MovieDetail>> call(String imdbID) async {
    return _repository.getMovieDetail(imdbID);
  }
}