import 'package:equatable/equatable.dart';
import 'package:movie_app/features/movie_detail/data/models/MovieDetailModel.dart';
import 'package:movie_app/features/movie_list/data/models/MovieListModel.dart';

class MovieListState extends Equatable {
  final String message;
  final bool isLoading;
  final bool isFailure;
  final bool isSuccess;

  final List<MovieListModel> defaultMovies;
  final List<MovieListModel> searchedMovies;
  final Map<String, MovieDetailModel> movieDetails;

  final bool hasMoreDefault;
  final bool hasMoreSearch;

  final bool isPaginatingDefault;   // ✅ new flag
  final bool isPaginatingSearch;    // ✅ new flag

  final String? year;

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
    this.isPaginatingDefault = false,   // ✅ default false
    this.isPaginatingSearch = false,    // ✅ default false
    this.year,
  });

  MovieListState copyWith({
    String? message,
    bool? isLoading,
    bool? isFailure,
    bool? isSuccess,
    List<MovieListModel>? defaultMovies,
    List<MovieListModel>? searchedMovies,
    Map<String, MovieDetailModel>? movieDetails,
    bool? hasMoreDefault,
    bool? hasMoreSearch,
    bool? isPaginatingDefault,
    bool? isPaginatingSearch,
    String? year,
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
      isPaginatingDefault: isPaginatingDefault ?? this.isPaginatingDefault,
      isPaginatingSearch: isPaginatingSearch ?? this.isPaginatingSearch,
      year: year ?? this.year,
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
    isPaginatingDefault,
    isPaginatingSearch,
    year,
  ];
}