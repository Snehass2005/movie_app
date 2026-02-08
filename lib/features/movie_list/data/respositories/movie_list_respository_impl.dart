import '../../../../core/exceptions/http_exception.dart';
import '../../../../core/network/model/either.dart';
import '../datasources/movie_remote_datasource.dart';
import '../models/MovieListModel.dart';
import '../../domain/respositories/movie_list_respository.dart';

/// Implementation of [MovieListRepository] that fetches movies from a remote data source
class MovieListRepositoryImpl implements MovieListRepository {
  final MovieRemoteDataSource _remoteDataSource;

  MovieListRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppException, List<MovieListModel>>> searchMovies({
    required String query,
    String? year,
    int page = 1,
  }) async {
    return _remoteDataSource.searchMovies(query, page: page,year: year);
  }
}