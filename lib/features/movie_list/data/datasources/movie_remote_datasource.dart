import 'package:movie_app/core/constants/endpoints.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/core/network/network_service.dart';
import '../models/movie_list_dto.dart';

/// Contract for movie list remote data source
abstract class MovieRemoteDataSource {
  Future<Either<AppException, List<MovieListDto>>> searchMovies(
      String query, {
        int page,
      });
}

/// Implementation using [NetworkService]
class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final NetworkService networkService;

  MovieRemoteDataSourceImpl(this.networkService);

  @override
  Future<Either<AppException, List<MovieListDto>>> searchMovies(
      String query, {
        int page = 1,
      }) async {
    try {
      final eitherType = await networkService.get(
        '/', // OMDb root endpoint
        queryParameters: {
          ApiEndpoint.searchParam: query,
          ApiEndpoint.pageParam: '$page',
        },
      );

      return eitherType.fold(
            (exception) => Left(exception),
            (response) {
          final results = (response.data['Search'] as List<dynamic>?)
              ?.map((json) => MovieListDto.fromJson(json))
              .toList();

          return Right(results ?? []);
        },
      );
    } catch (e) {
      return Left(
        AppException(
          message: e.toString(),
          statusCode: -1,
          identifier: 'MovieRemoteDataSource.searchMovies',
        ),
      );
    }
  }
}