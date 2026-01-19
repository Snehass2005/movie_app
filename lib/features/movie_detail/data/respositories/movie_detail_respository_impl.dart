import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_detail/data/datasources/movie_detail_remote_datasource.dart';
import 'package:movie_app/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:movie_app/features/movie_detail/domain/respositories/movie_detail_respository.dart';


class MovieDetailRepositoryImpl implements MovieDetailRepository {
  final MovieDetailRemoteDataSource _remoteDataSource;

  MovieDetailRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppException, MovieDetail>> getMovieDetail(String imdbID) async {
    final result = await _remoteDataSource.getMovieDetail(imdbID: imdbID);

    return result.fold(
          (error) => Left<AppException, MovieDetail>(error),
          (dto) => Right<AppException, MovieDetail>(dto.toEntity()), // ✅ map DTO → Entity
    );
  }
}