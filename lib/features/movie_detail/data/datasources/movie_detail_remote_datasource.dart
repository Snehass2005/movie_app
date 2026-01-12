import 'package:movie_app/core/constants/endpoints.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/core/network/api_client.dart';
import 'package:movie_app/core/network/model/safe_api_call.dart';
import '../models/movie_detail_dto.dart';

abstract class MovieDetailRemoteDataSource {
  Future<Either<AppException, MovieDetailDto>> getMovieDetail(String imdbID);
}

class MovieDetailRemoteDataSourceImpl implements MovieDetailRemoteDataSource {
  final ApiClient apiClient;

  MovieDetailRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Either<AppException, MovieDetailDto>> getMovieDetail(String imdbID) {
    return safeApiCall(() async {
      final data = await apiClient.get({
        ApiEndpoint.byId: imdbID,
      });

      return MovieDetailDto.fromJson(data);
    }, identifier: 'MovieDetailRemoteDataSource.getMovieDetail');
  }
}