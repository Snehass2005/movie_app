import 'dart:developer';
import 'package:movie_app/core/constants/endpoints.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/core/network/network_service.dart';
import '../models/MovieListModel.dart';

abstract class MovieRemoteDataSource {
  Future<Either<AppException, List<MovieListModel>>> searchMovies(
      String query, {
        int page,
        String? year,
      });
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final NetworkService networkService;

  MovieRemoteDataSourceImpl(this.networkService);

  @override
  Future<Either<AppException, List<MovieListModel>>> searchMovies(
      String query, {
        int page = 1,
        String? year,
      }) async {
    try {
      final queryParams = {
        's': query,
        'page': '$page',
      };

      if (year != null && year.isNotEmpty) {
        queryParams['y'] = year;
      }

      final eitherType = await networkService.get(
        ApiEndpoint.searchMovies,
        queryParameters: queryParams,
      );

      return eitherType.fold(
            (exception) => Left(exception),
            (response) {
          log('SearchMovies Response: ${response.data}');

          if (response.data is Map<String, dynamic> &&
              response.data['Response'] == 'False') {
            final errorMsg = response.data['Error'] ?? 'Unknown error occurred';
            return Left(AppException(
              message: errorMsg,
              statusCode: response.statusCode ?? -1,
              identifier: 'MovieRemoteDataSource.searchMovies',
            ));
          }

          final results = (response.data['Search'] as List<dynamic>?)
              ?.map((json) => MovieListModel.fromJson(json))
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