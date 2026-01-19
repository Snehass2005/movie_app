import 'package:get_it/get_it.dart';

import 'package:movie_app/core/network/network_service.dart';
import 'package:movie_app/core/network/dio_network_service.dart';
import 'package:movie_app/features/movie_detail/presentation/cubit/movie_detail_cubit.dart';

// Movie list
import 'package:movie_app/features/movie_list/data/datasources/movie_remote_datasource.dart';
import 'package:movie_app/features/movie_list/data/respositories/movie_list_respository_impl.dart';
import 'package:movie_app/features/movie_list/domain/usecases/movie_search_usecases.dart';
import 'package:movie_app/features/movie_list/presentation/cubit/movie_list_cubit.dart';

// Movie detail
import 'package:movie_app/features/movie_detail/data/datasources/movie_detail_remote_datasource.dart';
import 'package:movie_app/features/movie_detail/data/respositories/movie_detail_respository_impl.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';

final injector = GetIt.instance;

Future<void> initDependencies({
  required String omdbBaseUrl,
  required String omdbApiKey,
}) async {
  injector
  // Core
    ..registerLazySingleton<NetworkService>(
          () => DioNetworkService(), // ✅ concrete implementation
    )

  // Data sources
    ..registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(injector<NetworkService>()),
    )

    ..registerLazySingleton<MovieDetailRemoteDataSource>(
          () => MovieDetailRemoteDataSourceImpl(injector<NetworkService>()),
    )

  // Repositories
    ..registerLazySingleton<MovieListRepositoryImpl>(
          () => MovieListRepositoryImpl(injector<MovieRemoteDataSource>()),
    )
    ..registerLazySingleton<MovieDetailRepositoryImpl>(
          () => MovieDetailRepositoryImpl(injector<MovieDetailRemoteDataSource>()),
    )

  // Use cases
    ..registerLazySingleton<SearchMoviesUseCase>(
          () => SearchMoviesUseCase(injector<MovieListRepositoryImpl>()),
    )
    ..registerLazySingleton<GetMovieDetailUseCase>(
          () => GetMovieDetailUseCase(injector<MovieDetailRepositoryImpl>()),
    )

  // Cubits
    ..registerFactory<MovieListCubit>(
          () => MovieListCubit(
        injector<SearchMoviesUseCase>(),
        injector<GetMovieDetailUseCase>(),
      ),
    )

    ..registerFactory<MovieDetailCubit>(
          () => MovieDetailCubit(injector<GetMovieDetailUseCase>()),
    );
}