import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_detail/data/datasources/movie_detail_remote_datasource.dart';
import 'package:movie_app/features/movie_detail/domain/respositories/movie_detail_respository.dart';
import 'package:movie_app/features/movie_detail/data/models/movie_detail_dto.dart';

class MovieDetailRepositoryImpl implements MovieDetailRepository {
  final MovieDetailRemoteDataSource _remoteDataSource;

  MovieDetailRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppException, MovieDetailDto>> getMovieDetail(String imdbID) {
    return _remoteDataSource.getMovieDetail(imdbID);
  }
}