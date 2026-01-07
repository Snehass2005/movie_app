import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/core/network/api_client.dart';
import '../models/movie_detail_dto.dart';

/// Remote datasource for fetching movie details from OMDb API.
/// Wraps responses in Either<AppException, MovieDetailDto>.
abstract class MovieDetailRemoteDataSource {
  Future<Either<AppException, MovieDetailDto>> getMovieDetail(String imdbID);
}

class MovieDetailRemoteDataSourceImpl implements MovieDetailRemoteDataSource {
  final ApiClient apiClient;

  MovieDetailRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Either<AppException, MovieDetailDto>> getMovieDetail(String imdbID) async {
    try {
      final data = await apiClient.get('', {'i': imdbID});
      final detail = MovieDetailDto.fromJson(data);
      return Right(detail);
    } catch (e) {
      return Left(
        AppException(
          message: 'Failed to fetch movie detail',
          statusCode: 1,
          identifier: '${e.toString()}\nMovieDetailRemoteDataSource.getMovieDetail',
        ),
      );
    }
  }
}