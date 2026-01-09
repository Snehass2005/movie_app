import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movie_list/domain/usecases/movie_search_usecases.dart';
import '../../data/models/movie_list_dto.dart';

part 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final SearchMoviesUseCase searchMoviesUseCase;

  List<MovieListDto> defaultMovies = [];
  List<MovieListDto> searchedMovies = [];

  MovieListCubit(this.searchMoviesUseCase)
      : super(const MovieListSuccess([], []));

  /// Generic loader (used by both pages)
  Future<void> loadMovies({String query = "batman"}) async {
    emit(state.copyWith(isLoading: true));
    final result = await searchMoviesUseCase(query);
    result.fold(
          (failure) => emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: failure.message,
      )),
          (movies) {
        defaultMovies = movies;
        emit(MovieListSuccess(defaultMovies, searchedMovies));
      },
    );
  }

  /// Search movies by query
  Future<void> search(String query) async {
    emit(state.copyWith(isLoading: true));
    final result = await searchMoviesUseCase(query);
    result.fold(
          (failure) => emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: failure.message,
      )),
          (movies) {
        searchedMovies = movies;
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

  void resetError() {
    emit(state.copyWith(isLoading: false, isError: false, errorMessage: ''));
  }
}