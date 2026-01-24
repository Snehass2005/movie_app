import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:movie_app/core/constants/routes.dart';
import 'package:movie_app/features/movie_list/presentation/pages/movie_list_page.dart';
import 'package:movie_app/features/movie_detail/presentation/pages/movie_detail_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RoutesName.defaultPath,
  routes: [
    GoRoute(
      path: RoutesName.defaultPath, // '/'
      name: 'home',
      builder: (context, state) {
        return const MovieListPage(); // ✅ no parameters
      },
    ),
    GoRoute(
      path: '${RoutesName.movieDetail}/:imdbID', // '/movie-details/:imdbID'
      name: 'detail',
      builder: (context, state) {
        final imdbID = state.pathParameters['imdbID']!;
        return MovieDetailPage(imdbID: imdbID); // ✅ passes imdbID
      },
    ),
  ],
);