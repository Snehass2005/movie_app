import 'dart:developer';

import 'package:movie_app/core/constants/endpoints.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/core/network/network_service.dart';
import 'package:movie_app/features/movie_detail/data/models/movie_detail_dto.dart';
import 'package:movie_app/core/network/model/response.dart';
import 'package:movie_app/main/app_env.dart';

/// Contract for movie detail remote data source
abstract class MovieDetailRemoteDataSource {
  Future<Either<AppException, MovieDetailDto>> getMovieDetail({
    required String imdbID,
  });
}

/// Implementation using [NetworkService]
class MovieDetailRemoteDataSourceImpl implements MovieDetailRemoteDataSource {
  final NetworkService networkService;

  MovieDetailRemoteDataSourceImpl(this.networkService);

  @override
  Future<Either<AppException, MovieDetailDto>> getMovieDetail({
    required String imdbID,
  }) async {
      try {
        final eitherType = await networkService.get(
          ApiEndpoint.movieDetail,
          queryParameters: {
            'i': imdbID,              // IMDb ID
          },
        );

        return eitherType.fold(
            (exception) => Left(exception),
            (response) {
              log('MovieDetail Response: ${response.data}');
              final movieDetail = MovieDetailDto.fromJson(response.data);
          return Right(movieDetail);
        },
      );
    } catch (e) {
      return Left(
        AppException(
          message: e.toString(),
          statusCode: -1,
          identifier: 'MovieDetailRemoteDataSource.getMovieDetail',
        ),
      );
    }
  }
}