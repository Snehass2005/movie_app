import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/exceptions/exception_handler_mixin.dart';
import 'package:movie_app/features/movie_detail/data/models/MovieDetailModel.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_list/data/models/MovieListModel.dart';
import 'package:movie_app/features/movie_list/domain/usecases/movie_search_usecases.dart';
import 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> with ExceptionHandlerMixin {
  final SearchMoviesUseCase searchMoviesUseCase;
  final GetMovieDetailUseCase getMovieDetailUseCase;

  int defaultPage = 1;
  int searchPage = 1;

  MovieListCubit(this.searchMoviesUseCase, this.getMovieDetailUseCase)
      : super(const MovieListState());

  Future<void> loadMovies({String query = "batman", String? year}) async {
    emit(state.copyWith(isLoading: true, message: '', isFailure: false));
    defaultPage = 1;

    final result = await searchMoviesUseCase(
      query: query,
      page: defaultPage,
      year: year,
    );

    result.onLeft((failure) {
      emit(state.copyWith(
        message: getErrorMessage(failure),
        isLoading: false,
        isFailure: true,
        isSuccess: false,
      ));
    });

    result.onRight((movies) {
      log('Loaded page $defaultPage for query: $query, year: $year');
      emit(state.copyWith(
        defaultMovies: _dedupe(movies),
        searchedMovies: [],
        hasMoreDefault: movies.isNotEmpty,
        isLoading: false,
        isSuccess: true,
        isFailure: false,
        year: year,
      ));
    });
  }

  Future<void> search(String query, {String? year}) async {
    emit(state.copyWith(isLoading: true, message: '', isFailure: false));
    searchPage = 1;

    final result = await searchMoviesUseCase(
      query: query,
      page: searchPage,
      year: year,
    );

    result.onLeft((failure) {
      emit(state.copyWith(
        message: getErrorMessage(failure),
        isLoading: false,
        isFailure: true,
        isSuccess: false,
      ));
    });

    result.onRight((movies) {
      emit(state.copyWith(
        searchedMovies: _dedupe(movies),
        hasMoreSearch: movies.isNotEmpty,
        isLoading: false,
        isSuccess: true,
        isFailure: false,
        year: year,
      ));
    });
  }

  Future<void> loadMoreMovies(String query, {String? year}) async {
    if (!state.hasMoreDefault || state.isPaginatingDefault) return;

    emit(state.copyWith(isPaginatingDefault: true));
    defaultPage++;

    final result = await searchMoviesUseCase(
      query: query,
      page: defaultPage,
      year: year,
    );

    result.onRight((movies) {
      if (movies.isEmpty) {
        emit(state.copyWith(hasMoreDefault: false, isPaginatingDefault: false));
        log('No more pages left for query: $query, year: $year');
      } else {
        emit(state.copyWith(
          defaultMovies: _dedupe([...state.defaultMovies, ...movies]),
          hasMoreDefault: true,
          isPaginatingDefault: false,
          isSuccess: true,
          isFailure: false,
          year: year,
        ));
      }
    });

    result.onLeft((failure) {
      emit(state.copyWith(
        message: getErrorMessage(failure),
        isPaginatingDefault: false,
        isFailure: true,
      ));
    });
  }

  Future<void> loadMoreSearch(String query, {String? year}) async {
    if (!state.hasMoreSearch || state.isPaginatingSearch) return;

    emit(state.copyWith(isPaginatingSearch: true));
    searchPage++;

    final result = await searchMoviesUseCase(
      query: query,
      page: searchPage,
      year: year,
    );

    result.onRight((movies) {
      if (movies.isEmpty) {
        emit(state.copyWith(hasMoreSearch: false, isPaginatingSearch: false));
      } else {
        emit(state.copyWith(
          searchedMovies: _dedupe([...state.searchedMovies, ...movies]),
          hasMoreSearch: true,
          isPaginatingSearch: false,
          isSuccess: true,
          isFailure: false,
          year: year,
        ));
      }
    });

    result.onLeft((failure) {
      emit(state.copyWith(
        message: getErrorMessage(failure),
        isPaginatingSearch: false,
        isFailure: true,
      ));
    });
  }

  List<MovieListModel> _dedupe(List<MovieListModel> movies) {
    final map = <String, MovieListModel>{};
    for (final m in movies) {
      map[m.imdbID] = m;
    }
    return map.values.toList();
  }

  Future<void> loadMovieDetail(String imdbID) async {
    if (state.movieDetails.containsKey(imdbID)) return;

    final result = await getMovieDetailUseCase.getMovieDetail(imdbID: imdbID);

    result.onRight((detail) {
      final updated = Map<String, MovieDetailModel>.from(state.movieDetails);
      updated[imdbID] = detail;
      emit(state.copyWith(movieDetails: updated));
    });
  }
}