import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_list/data/datasources/movie_remote_datasource.dart';
import 'package:movie_app/features/movie_list/data/models/movie_list_dto.dart';
import 'package:movie_app/features/movie_list/domain/respositories/movie_list_respository.dart';

class MovieListRepositoryImpl implements MovieListRepository {
  final MovieRemoteDataSource _remoteDataSource;

  MovieListRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppException, List<MovieListDto>>> searchMovies(String query) {
    return _remoteDataSource.searchMovies(query);
  }
}