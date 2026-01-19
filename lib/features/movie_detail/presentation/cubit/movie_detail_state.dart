part of 'movie_detail_cubit.dart';


abstract class MovieDetailState extends Equatable {
  final bool isLoading;
  final bool isError;
  final String errorMessage;

  const MovieDetailState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [isLoading, isError, errorMessage];
}

class MovieDetailLoaded extends MovieDetailState {
  const MovieDetailLoaded({
    bool isLoading = false,
    bool isError = false,
    String errorMessage = '',
  }) : super(isLoading: isLoading, isError: isError, errorMessage: errorMessage);

  MovieDetailLoaded copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
  }) {
    return MovieDetailLoaded(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MovieDetailSuccess extends MovieDetailState {
  final MovieDetail detail; // ✅ now recognized

  const MovieDetailSuccess(this.detail);

  @override
  List<Object?> get props => [detail];
}