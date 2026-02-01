import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/exceptions/exception_handler_mixin.dart';
import 'package:movie_app/features/movie_detail/data/models/MovieDetailDto.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_list/data/models/MovieListDto.dart';
import 'package:movie_app/features/movie_list/domain/usecases/movie_search_usecases.dart';


import 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> with ExceptionHandlerMixin {
  final SearchMoviesUseCase searchMoviesUseCase;
  final GetMovieDetailUseCase getMovieDetailUseCase;

  int defaultPage = 1;
  int searchPage = 1;

  MovieListCubit(this.searchMoviesUseCase, this.getMovieDetailUseCase)
      : super(const MovieListState());

  /// Load default movies (page 1)
  Future<void> loadMovies({String query = "batman"}) async {
    emit(state.copyWith(isLoading: true, message: ''));
    defaultPage = 1;

    final result = await searchMoviesUseCase(query: query, page: defaultPage);

    result.onLeft((failure) {
      emit(state.copyWith(
        message: getErrorMessage(failure),
        isLoading: false,
        isFailure: true,
      ));
    });

    result.onRight((movies) {
      log('Loaded page $defaultPage for query: $query');
      log('Current defaultMovies length: ${state.defaultMovies.length}');

      emit(state.copyWith(
        defaultMovies: _dedupe(movies),
        searchedMovies: [],
        hasMoreDefault: movies.isNotEmpty,
        isLoading: false,
        isSuccess: true,
      ));
    });
  }

  /// Search movies (page 1)
  Future<void> search(String query) async {
    emit(state.copyWith(isLoading: true, message: ''));
    searchPage = 1;

    final result = await searchMoviesUseCase(query: query, page: searchPage);

    result.onLeft((failure) {
      emit(state.copyWith(
        message: getErrorMessage(failure),
        isLoading: false,
        isFailure: true,
      ));
    });

    result.onRight((movies) {
      emit(state.copyWith(
        searchedMovies: _dedupe(movies),
        hasMoreSearch: movies.isNotEmpty,
        isLoading: false,
        isSuccess: true,
      ));
    });
  }

  /// Load more default movies
  Future<void> loadMoreMovies(String query) async {
    if (!state.hasMoreDefault) return;
    defaultPage++;

    final result = await searchMoviesUseCase(query: query, page: defaultPage);

    result.onRight((movies) {
      if (movies.isEmpty) {
        emit(state.copyWith(hasMoreDefault: false));
        log('No more pages left for query: $query');

      } else {
        emit(state.copyWith(
          defaultMovies: _dedupe([...state.defaultMovies, ...movies]),
          hasMoreDefault: true,
        ));
      }
    });
  }

  /// Load more search results
  Future<void> loadMoreSearch(String query) async {
    if (!state.hasMoreSearch) return;
    searchPage++;

    final result = await searchMoviesUseCase(query: query, page: searchPage);

    result.onRight((movies) {
      if (movies.isEmpty) {
        emit(state.copyWith(hasMoreSearch: false));
      } else {
        emit(state.copyWith(
          searchedMovies: _dedupe([...state.searchedMovies, ...movies]),
          hasMoreSearch: true,
        ));
      }
    });
  }

  /// Deduplicate movies
  List<MovieListDto> _dedupe(List<MovieListDto> movies) {
    final map = <String, MovieListDto>{};
    for (final m in movies) {
      map[m.imdbID] = m;
    }
    return map.values.toList();
  }

  /// Fetch movie detail once and cache it
  Future<void> loadMovieDetail(String imdbID) async {
    if (state.movieDetails.containsKey(imdbID)) return;

    final result = await getMovieDetailUseCase.getMovieDetail(imdbID: imdbID);

    result.onRight((detail) {
      final updated = Map<String, MovieDetailDto>.from(state.movieDetails);
      updated[imdbID] = detail;
      emit(state.copyWith(movieDetails: updated));
    });
  }
}