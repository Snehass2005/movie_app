import 'package:equatable/equatable.dart';
import 'package:movie_app/features/movie_detail/data/models/MovieDetailModel.dart';


/// MovieDetailState - Holds all the data for the movie detail screen.
///
/// Properties:
/// - message: Error or success message
/// - isLoading: True when API call is in progress
/// - isFailure: True when request failed
/// - isSuccess: True when request succeeded
/// - detail: The fetched MovieDetailDto (nullable until loaded)
class MovieDetailState extends Equatable {
  final String message;
  final bool isLoading;
  final bool isFailure;
  final bool isSuccess;
  final MovieDetailModel? detail;

  const MovieDetailState({
    this.message = '',
    this.isLoading = false,
    this.isFailure = false,
    this.isSuccess = false,
    this.detail,
  });

  MovieDetailState copyWith({
    String? message,
    bool? isLoading,
    bool? isFailure,
    bool? isSuccess,
    MovieDetailModel? detail,
  }) {
    return MovieDetailState(
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess,
      detail: detail ?? this.detail,
    );
  }

  @override
  List<Object?> get props => [message, isLoading, isFailure, isSuccess, detail];
}