import 'package:flutter/material.dart';
import 'package:movie_app/core/dependency_injection/injector.dart';
import 'package:movie_app/features/movie_list/presentation/cubit/movie_list_cubit.dart';
import 'package:movie_app/features/movie_list/presentation/pages/movie_list_page.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: MovieListPage(
        cubit: injector<MovieListCubit>(), // ✅ resolved via GetIt
        getMovieDetailUseCase: injector<GetMovieDetailUseCase>(),
      ),
    );
  }
}