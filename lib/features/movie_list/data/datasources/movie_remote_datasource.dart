import 'package:movie_app/core/constants/endpoints.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/core/network/api_client.dart';
import 'package:movie_app/core/network/model/safe_api_call.dart';
import '../models/movie_list_dto.dart';

abstract class MovieRemoteDataSource {
  Future<Either<AppException, List<MovieListDto>>> searchMovies(String query, {int page});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiClient apiClient;

  MovieRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Either<AppException, List<MovieListDto>>> searchMovies(
      String query, {int page = 1}) {
    return safeApiCall(() async {
      final data = await apiClient.get({
        ApiEndpoint.search: query,
        ApiEndpoint.page: '$page',
      });

      final results = (data['Search'] as List<dynamic>?)
          ?.map((json) => MovieListDto.fromJson(json))
          .toList();

      return results ?? [];
    }, identifier: 'MovieRemoteDataSource.searchMovies');
  }
}