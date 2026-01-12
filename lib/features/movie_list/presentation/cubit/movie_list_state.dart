part of 'movie_list_cubit.dart';

class MovieListState extends Equatable {
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final List<Movie> defaultMovies;
  final List<Movie> searchedMovies;

  const MovieListState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
    this.defaultMovies = const [],
    this.searchedMovies = const [],
  });

  MovieListState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<Movie>? defaultMovies,
    List<Movie>? searchedMovies,
  }) {
    return MovieListState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      defaultMovies: defaultMovies ?? this.defaultMovies,
      searchedMovies: searchedMovies ?? this.searchedMovies,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isError, errorMessage, defaultMovies, searchedMovies];
}

class MovieListInitial extends MovieListState {
  const MovieListInitial() : super();
}

class MovieListLoading extends MovieListState {
  const MovieListLoading() : super(isLoading: true);
}

class MovieListSuccess extends MovieListState {
  const MovieListSuccess(List<Movie> defaultMovies, List<Movie> searchedMovies)
      : super(defaultMovies: defaultMovies, searchedMovies: searchedMovies);
}

class MovieListError extends MovieListState {
  const MovieListError(String message)
      : super(errorMessage: message, isError: true);
}