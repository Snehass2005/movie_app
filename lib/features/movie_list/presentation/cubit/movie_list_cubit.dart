import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movie_list/domain/usecases/movie_search_usecases.dart';
import 'package:movie_app/features/movie_list/domain/entities/movie.dart';

part 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final SearchMoviesUseCase searchMoviesUseCase;

  List<Movie> defaultMovies = [];
  List<Movie> searchedMovies = [];

  int currentPage = 1;
  bool hasMoreDefault = true;
  bool hasMoreSearch = true;

  MovieListCubit(this.searchMoviesUseCase)
      : super(const MovieListSuccess([], []));

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
        defaultMovies = movies;
        hasMoreDefault = movies.isNotEmpty;
        emit(MovieListSuccess(defaultMovies, searchedMovies));
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
          defaultMovies.addAll(movies);
        }
        emit(MovieListSuccess(defaultMovies, searchedMovies));
      },
    );
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
        searchedMovies = movies;
        hasMoreSearch = movies.isNotEmpty;

        // Prioritize titles starting with query
        searchedMovies.sort((a, b) {
          final aStarts =
          a.title.toLowerCase().startsWith(query.toLowerCase()) ? 0 : 1;
          final bStarts =
          b.title.toLowerCase().startsWith(query.toLowerCase()) ? 0 : 1;
          return aStarts.compareTo(bStarts);
        });

        emit(MovieListSuccess(defaultMovies, searchedMovies));
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
          searchedMovies.addAll(movies);
        }
        emit(MovieListSuccess(defaultMovies, searchedMovies));
      },
    );
  }

  void resetError() {
    emit(state.copyWith(isLoading: false, isError: false, errorMessage: ''));
  }
}