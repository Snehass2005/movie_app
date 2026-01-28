import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/exceptions/exception_handler_mixin.dart';
import 'package:movie_app/features/movie_detail/data/models/movie_detail_dto.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_list/domain/usecases/movie_search_usecases.dart';
import 'package:movie_app/features/movie_list/data/models/movie_list_dto.dart';

part 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> with ExceptionHandlerMixin {
  final SearchMoviesUseCase searchMoviesUseCase;
  final GetMovieDetailUseCase getMovieDetailUseCase;

  List<MovieListDto> defaultMovies = [];
  List<MovieListDto> searchedMovies = [];

  int defaultPage = 1;
  int searchPage = 1;
  bool hasMoreDefault = true;
  bool hasMoreSearch = true;

  MovieListCubit(this.searchMoviesUseCase, this.getMovieDetailUseCase)
      : super(const MovieListInitial());

  /// Load default movies (page 1)
  Future<void> loadMovies({String query = "batman"}) async {
    emit(const MovieListLoading());
    defaultPage = 1;
    defaultMovies.clear();

    final result = await searchMoviesUseCase(query: query, page: defaultPage);

    result.onLeft((failure) {
      emit(MovieListError(getErrorMessage(failure)));
    });

    result.onRight((movies) {
      defaultMovies = _dedupe(movies);
      hasMoreDefault = movies.isNotEmpty;
      emit(MovieListSuccess(defaultMovies, [], {}));
    });
  }

  /// Search movies (page 1)
  Future<void> search(String query) async {
    emit(const MovieListLoading());
    searchPage = 1;
    searchedMovies.clear();

    final result = await searchMoviesUseCase(query: query, page: searchPage);

    result.onLeft((failure) {
      emit(MovieListError(getErrorMessage(failure)));
    });

    result.onRight((movies) {
      searchedMovies = _dedupe(movies);
      hasMoreSearch = movies.isNotEmpty;
      emit(MovieListSuccess([], searchedMovies, {}));
    });
  }

  /// Load more default movies
  Future<void> loadMoreMovies(String query) async {
    if (!hasMoreDefault) return;
    defaultPage++;

    final result = await searchMoviesUseCase(query: query, page: defaultPage);

    result.onLeft((failure) {
      emit(MovieListError(getErrorMessage(failure)));
    });

    result.onRight((movies) {
      if (movies.isEmpty) {
        hasMoreDefault = false;
      } else {
        defaultMovies.addAll(_dedupe(movies));
      }
      emit(MovieListSuccess(defaultMovies, [], {}));
    });
  }

  /// Load more search results
  Future<void> loadMoreSearch(String query) async {
    if (!hasMoreSearch) return;
    searchPage++;

    final result = await searchMoviesUseCase(query: query, page: searchPage);

    result.onLeft((failure) {
      emit(MovieListError(getErrorMessage(failure)));
    });

    result.onRight((movies) {
      if (movies.isEmpty) {
        hasMoreSearch = false;
      } else {
        searchedMovies.addAll(_dedupe(movies));
      }
      emit(MovieListSuccess([], searchedMovies, {}));
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
    final currentState = state;
    if (currentState is MovieListSuccess &&
        currentState.movieDetails.containsKey(imdbID)) return;

    final result = await getMovieDetailUseCase.getMovieDetail(imdbID: imdbID);

    result.onLeft((failure) {
      emit(MovieListError(getErrorMessage(failure)));
    });

    result.onRight((detail) {
      if (currentState is MovieListSuccess) {
        final updated = Map<String, MovieDetailDto>.from(currentState.movieDetails);
        updated[imdbID] = detail;
        emit(MovieListSuccess(
          currentState.defaultMovies,
          currentState.searchedMovies,
          updated,
        ));
      }
    });
  }
}