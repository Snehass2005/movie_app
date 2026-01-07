import 'package:get_it/get_it.dart';

import 'package:movie_app/core/network/api_client.dart';
import 'package:movie_app/core/network/connection/connection_listener.dart';
import 'package:movie_app/core/network/network_service_impl.dart';
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
    ..registerLazySingleton<ApiClient>(
          () => ApiClient(baseUrl: omdbBaseUrl, apiKey: omdbApiKey),
    )
    ..registerLazySingleton<ConnectionStatusListener>(
          () => ConnectionStatusListener.getInstance(), // ✅ fixed
    )
    ..registerLazySingleton<NetworkServiceImpl>(
          () => NetworkServiceImpl(
        apiClient: injector<ApiClient>(),
        connectionListener: injector<ConnectionStatusListener>(), // ✅ fixed
      ),
    )

  // Data sources
    ..registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(injector<ApiClient>()),
    )
    ..registerLazySingleton<MovieDetailRemoteDataSource>(
          () => MovieDetailRemoteDataSourceImpl(injector<ApiClient>()),
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
          () => MovieListCubit(injector<SearchMoviesUseCase>()), // ✅ if constructor takes arg
    )
    ..registerFactory<MovieDetailCubit>(
          () => MovieDetailCubit(injector<GetMovieDetailUseCase>()),
    );

}