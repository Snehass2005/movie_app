import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:movie_app/core/constants/routes.dart';
import 'package:movie_app/core/dependency_injection/injector.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_list/presentation/cubit/movie_list_cubit.dart';
import 'package:movie_app/features/movie_list/presentation/pages/movie_list_page.dart';
import 'package:movie_app/features/movie_detail/presentation/pages/movie_detail_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RoutesName.defaultPath,
  routes: <RouteBase>[
    GoRoute(
      path: RoutesName.defaultPath, // e.g. '/'
      builder: (BuildContext context, GoRouterState state) {
        return MovieListPage(
          cubit: injector<MovieListCubit>(),
          getMovieDetailUseCase: injector<GetMovieDetailUseCase>(),
        );
      },
    ),
    GoRoute(
      path: RoutesName.movieDetail, // e.g. '/movie-details'
      builder: (BuildContext context, GoRouterState state) {
        final imdbID = state.extra as String;
        return MovieDetailPage(imdbID: imdbID);
      },
    ),
  ],
);