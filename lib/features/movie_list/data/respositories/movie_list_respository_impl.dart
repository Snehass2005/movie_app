import 'package:movie_app/core/constants/app_constants.dart';

import '../../../../core/exceptions/http_exception.dart';
import '../../../../core/network/model/either.dart';
import '../datasources/movie_remote_datasource.dart';
import '../models/movie_list_dto.dart';
import '../../domain/entities/movie.dart';
import '../../domain/respositories/movie_list_respository.dart';

/// Implementation of [MovieListRepository] that fetches movies from a remote data source
class MovieListRepositoryImpl implements MovieListRepository {
  final MovieRemoteDataSource _remoteDataSource;

  MovieListRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppException, List<Movie>>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final result = await _remoteDataSource.searchMovies(query, page: page);


    return result.fold(
          (error) => Left<AppException, List<Movie>>(error),
          (dtoList) {
        final entities = dtoList.map(_mapDtoToEntity).toList();
        return Right<AppException, List<Movie>>(entities);
      },
    );
  }

  /// Maps [MovieListDto] from the data layer into a [Movie] entity for the domain layer
  Movie _mapDtoToEntity(MovieListDto dto) {
    return Movie(
      imdbID: dto.imdbID,
      title: dto.title,
      year: dto.year,
      type: dto.type,
      posterUrl: dto.poster.isNotEmpty
          ? dto.poster
          : AppConstants.noPosterUrl,
    );
  }
}