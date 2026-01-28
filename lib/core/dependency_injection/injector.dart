import 'package:get_it/get_it.dart';

import 'package:movie_app/core/network/network_service.dart';
import 'package:movie_app/core/network/dio_network_service.dart';

// Movie list
import 'package:movie_app/features/movie_list/data/datasources/movie_remote_datasource.dart';
import 'package:movie_app/features/movie_list/data/respositories/movie_list_respository_impl.dart';
import 'package:movie_app/features/movie_list/domain/respositories/movie_list_respository.dart';
import 'package:movie_app/features/movie_list/domain/usecases/movie_search_usecases.dart';

// Movie detail
import 'package:movie_app/features/movie_detail/data/datasources/movie_detail_remote_datasource.dart';
import 'package:movie_app/features/movie_detail/data/respositories/movie_detail_respository_impl.dart';
import 'package:movie_app/features/movie_detail/domain/respositories/movie_detail_respository.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';


// Environment
import 'package:movie_app/main/app_env.dart';

final injector = GetIt.instance;

Future<void> initDependencies() async {
  injector
  // Core
    ..registerLazySingleton<NetworkService>(
          () => DioNetworkService(),
    )

  // Data sources (inject EnvInfo.baseUrl and EnvInfo.apiKey here)
    ..registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(injector<NetworkService>()),
    )
    ..registerLazySingleton<MovieDetailRemoteDataSource>(
          () => MovieDetailRemoteDataSourceImpl(injector<NetworkService>()),
    )

  // Repositories
    ..registerLazySingleton<MovieListRepository>(
          () => MovieListRepositoryImpl(injector<MovieRemoteDataSource>()),
    )
    ..registerLazySingleton<MovieDetailRepository>(
          () => MovieDetailRepositoryImpl(injector<MovieDetailRemoteDataSource>()),
    )

  // Use cases
    ..registerLazySingleton<SearchMoviesUseCase>(
          () => SearchMoviesUseCase(injector<MovieListRepository>()),
    )
    ..registerLazySingleton<GetMovieDetailUseCase>(
          () => GetMovieDetailUseCase(injector<MovieDetailRepository>()),
    );
}