part of 'movie_list_cubit.dart';

abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object?> get props => [];
}

class MovieListInitial extends MovieListState {
  const MovieListInitial();
}

class MovieListLoading extends MovieListState {
  const MovieListLoading();
}

class MovieListSuccess extends MovieListState {
  final List<MovieListDto> defaultMovies;
  final List<MovieListDto> searchedMovies;
  final Map<String,MovieDetailDto> movieDetails;

  const MovieListSuccess(this.defaultMovies, this.searchedMovies, this.movieDetails);

  @override
  List<Object?> get props => [defaultMovies, searchedMovies, movieDetails];
}

class MovieListError extends MovieListState {
  final String message;
  const MovieListError(this.message);

  @override
  List<Object?> get props => [message];
}