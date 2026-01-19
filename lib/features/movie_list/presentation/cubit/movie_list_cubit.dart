import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_list/domain/usecases/movie_search_usecases.dart';
import 'package:movie_app/features/movie_list/domain/entities/movie.dart';

part 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final SearchMoviesUseCase searchMoviesUseCase;
  final GetMovieDetailUseCase getMovieDetailUseCase;

  List<Movie> defaultMovies = [];
  List<Movie> searchedMovies = [];

  int currentPage = 1;
  bool hasMoreDefault = true;
  bool hasMoreSearch = true;

  MovieListCubit(this.searchMoviesUseCase, this.getMovieDetailUseCase)
      : super(const MovieListSuccess([], [], {}));

  /// Load initial movies (page 1)
  Future<void> loadMovies({String query = "batman"}) async {
    emit(state.copyWith(isLoading: true));
    currentPage = 1;
    final result = await searchMoviesUseCase(query, page: currentPage);
    result.fold(
          (failure) => emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: failure.message,
      )),
          (movies) {
        defaultMovies = _dedupe(movies);
        hasMoreDefault = movies.isNotEmpty;
        emit(MovieListSuccess(defaultMovies, searchedMovies, state.movieDetails));
      },
    );
  }

  /// Helper to remove duplicate movies by imdbID
  List<Movie> _dedupe(List<Movie> movies) {
    final map = <String, Movie>{};
    for (final m in movies) {
      map[m.imdbID] = m;
    }
    return map.values.toList();
  }

  /// Local filter for single-letter queries
  List<Movie> _filterByQuery(String query) {
    final q = query.trim().toLowerCase();
    return defaultMovies.where(
          (m) => m.title.toLowerCase().contains(q),
    ).toList();
  }

  /// Hybrid search handler
  Future<void> handleSearch(String query) async {
    final q = query.trim();

    // Empty query → show default list
    if (q.isEmpty) {
      emit(MovieListSuccess(defaultMovies, [], state.movieDetails));
      return;
    }

    // Single letter → local filter from defaultMovies
    if (q.length == 1) {
      final filtered = _filterByQuery(q);
      emit(MovieListSuccess(defaultMovies, filtered, state.movieDetails));
      return;
    }

    // ✅ For ≥ 2 characters → always call OMDb API
    await search(q);
  }

  /// Search movies by query (page 1)
  Future<void> search(String query) async {
    emit(state.copyWith(isLoading: true));
    currentPage = 1;
    final result = await searchMoviesUseCase(query, page: currentPage);
    result.fold(
          (failure) => emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: failure.message,
      )),
          (movies) {
        searchedMovies = _dedupe(
          movies.where(
                (m) => m.title.toLowerCase().contains(query.toLowerCase()),
          ).toList(),
        );

        // 🔑 Fallback: if OMDb returns nothing, filter locally from defaultMovies
        if (searchedMovies.isEmpty) {
          searchedMovies = _filterByQuery(query);
        }

        hasMoreSearch = searchedMovies.isNotEmpty;
        emit(MovieListSuccess(defaultMovies, searchedMovies, state.movieDetails));
      },
    );
  }

  /// Load more movies for infinite scroll
  Future<void> loadMoreMovies(String query) async {
    if (!hasMoreDefault) return;
    emit(state.copyWith(isLoading: true));
    currentPage++;
    final result = await searchMoviesUseCase(query, page: currentPage);
    result.fold(
          (failure) => emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: failure.message,
      )),
          (movies) {
        if (movies.isEmpty) {
          hasMoreDefault = false;
        } else {
          defaultMovies.addAll(_dedupe(movies));
        }
        emit(MovieListSuccess(defaultMovies, searchedMovies, state.movieDetails));
      },
    );
  }

  /// Load more search results
  Future<void> loadMoreSearch(String query) async {
    if (!hasMoreSearch) return;
    emit(state.copyWith(isLoading: true));
    currentPage++;
    final result = await searchMoviesUseCase(query, page: currentPage);
    result.fold(
          (failure) => emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: failure.message,
      )),
          (movies) {
        if (movies.isEmpty) {
          hasMoreSearch = false;
        } else {
          searchedMovies.addAll(_dedupe(movies));
        }
        emit(MovieListSuccess(defaultMovies, searchedMovies, state.movieDetails));
      },
    );
  }

  /// Fetch movie detail once and cache it
  Future<void> loadMovieDetail(String imdbID) async {
    if (state.movieDetails.containsKey(imdbID)) return; // ✅ cached

    final result = await getMovieDetailUseCase(imdbID);
    result.fold(
          (failure) => emit(state.copyWith(
        isError: true,
        errorMessage: failure.message,
      )),
          (detail) {
        final updated = Map<String, MovieDetail>.from(state.movieDetails);
        updated[imdbID] = detail;
        emit(state.copyWith(movieDetails: updated));
      },
    );
  }

  /// Reset error state
  void resetError() {
    emit(state.copyWith(isLoading: false, isError: false, errorMessage: ''));
  }

  /// Reset search results
  void resetSearch() {
    searchedMovies = [];
    emit(MovieListSuccess(defaultMovies, searchedMovies, state.movieDetails));
  }
}