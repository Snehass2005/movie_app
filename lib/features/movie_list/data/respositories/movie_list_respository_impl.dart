import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_list/data/datasources/movie_remote_datasource.dart';
import 'package:movie_app/features/movie_list/data/models/movie_list_dto.dart';
import 'package:movie_app/features/movie_list/domain/entities/movie.dart';
import 'package:movie_app/features/movie_list/domain/respositories/movie_list_respository.dart';

class MovieListRepositoryImpl implements MovieListRepository {
  final MovieRemoteDataSource _remoteDataSource;

  MovieListRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppException, List<Movie>>> searchMovies(
      String query, {int page = 1}
      ) async {
    final result = await _remoteDataSource.searchMovies(query, page: page);

    // ✅ Use fold to unwrap Either<AppException, List<MovieListDto>>
    return result.fold(
          (error) => Left<AppException, List<Movie>>(error),
          (dtoList) {
        final entities = dtoList.map(_mapDtoToEntity).toList();
        return Right<AppException, List<Movie>>(entities);
      },
    );
  }

  Movie _mapDtoToEntity(MovieListDto dto) {
    return Movie(
      imdbID: dto.imdbID,
      title: dto.title,
      year: dto.year,
      type: dto.type,
      posterUrl: dto.poster,
    );
  }
}