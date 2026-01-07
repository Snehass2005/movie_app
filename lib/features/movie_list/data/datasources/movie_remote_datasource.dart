import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/core/network/api_client.dart';
import '../models/movie_list_dto.dart';

/// Remote datasource for fetching movie lists from OMDb API.
/// Wraps responses in Either<AppException, List<MovieListDto>>.
abstract class MovieRemoteDataSource {
  Future<Either<AppException, List<MovieListDto>>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiClient apiClient;

  MovieRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Either<AppException, List<MovieListDto>>> searchMovies(String query) async {
    try {
      final data = await apiClient.get('', {'s': query});
      final results = (data['Search'] as List<dynamic>?)
          ?.map((json) => MovieListDto.fromJson(json))
          .toList();

      return Right(results ?? []);
    } catch (e) {
      return Left(
        AppException(
          message: 'Failed to fetch movies',
          statusCode: 1,
          identifier: '${e.toString()}\nMovieRemoteDataSource.searchMovies',
        ),
      );
    }
  }
}