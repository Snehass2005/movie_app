import 'package:equatable/equatable.dart';
import 'package:movie_app/features/movie_detail/data/models/MovieDetailDto.dart';
import 'package:movie_app/features/movie_list/data/models/MovieListDto.dart';

/// MovieListState - Holds all the data for the movie list screen.
///
/// Properties:
/// - message: Error or success message
/// - isLoading: True when API call is in progress
/// - isFailure: True when request failed
/// - isSuccess: True when request succeeded
/// - defaultMovies: List of movies for default query (e.g. "batman")
/// - searchedMovies: List of movies for search query
/// - movieDetails: Cached map of imdbID -> MovieDetailDto
/// - hasMoreDefault: Whether more default movies can be loaded
/// - hasMoreSearch: Whether more search movies can be loaded
class MovieListState extends Equatable {
  final String message;
  final bool isLoading;
  final bool isFailure;
  final bool isSuccess;

  final List<MovieListDto> defaultMovies;
  final List<MovieListDto> searchedMovies;
  final Map<String, MovieDetailDto> movieDetails;

  final bool hasMoreDefault;
  final bool hasMoreSearch;

  const MovieListState({
    this.message = '',
    this.isLoading = false,
    this.isFailure = false,
    this.isSuccess = false,
    this.defaultMovies = const [],
    this.searchedMovies = const [],
    this.movieDetails = const {},
    this.hasMoreDefault = true,
    this.hasMoreSearch = true,
  });

  /// Creates a new state with some values changed.
  MovieListState copyWith({
    String? message,
    bool? isLoading,
    bool? isFailure,
    bool? isSuccess,
    List<MovieListDto>? defaultMovies,
    List<MovieListDto>? searchedMovies,
    Map<String, MovieDetailDto>? movieDetails,
    bool? hasMoreDefault,
    bool? hasMoreSearch,
  }) {
    return MovieListState(
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess,
      defaultMovies: defaultMovies ?? this.defaultMovies,
      searchedMovies: searchedMovies ?? this.searchedMovies,
      movieDetails: movieDetails ?? this.movieDetails,
      hasMoreDefault: hasMoreDefault ?? this.hasMoreDefault,
      hasMoreSearch: hasMoreSearch ?? this.hasMoreSearch,
    );
  }

  @override
  List<Object?> get props => [
    message,
    isLoading,
    isFailure,
    isSuccess,
    defaultMovies,
    searchedMovies,
    movieDetails,
    hasMoreDefault,
    hasMoreSearch,
  ];
}