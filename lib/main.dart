import 'package:flutter/material.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_list/presentation/cubit/movie_list_cubit.dart';
import 'package:movie_app/features/movie_list/presentation/pages/movie_list_page.dart';
import 'package:movie_app/main/app_env.dart';

import 'core/dependency_injection/injector.dart';

/// Common entrypoint used by main_dev.dart, main_stage.dart, main_prod.dart
Future<void> mainCommon(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment
  EnvInfo.initialize(environment);

  // Configure injector with OMDb API values
  await initDependencies(
    omdbBaseUrl: EnvInfo.baseUrl,
    omdbApiKey: EnvInfo.apiKey,
  );

  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: EnvInfo.appName, // ✅ dynamic title per environment
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MovieListPage(
        cubit: injector<MovieListCubit>(),
        getMovieDetailUseCase: injector<GetMovieDetailUseCase>(),
      ),
    );
  }
}