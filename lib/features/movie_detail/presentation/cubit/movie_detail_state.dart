part of 'movie_detail_cubit.dart';

class MovieDetailState extends Equatable {
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final MovieDetailDto? detail;

  const MovieDetailState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
    this.detail,
  });

  MovieDetailState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    MovieDetailDto? detail,
  }) {
    return MovieDetailState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      detail: detail ?? this.detail,
    );
  }

  @override
  List<Object?> get props => [isLoading, isError, errorMessage, detail];
}

class MovieDetailLoaded extends MovieDetailState {
  const MovieDetailLoaded() : super();
}

class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading() : super(isLoading: true);
}

class MovieDetailSuccess extends MovieDetailState {
  const MovieDetailSuccess(MovieDetailDto detail) : super(detail: detail);
}

class MovieDetailError extends MovieDetailState {
  const MovieDetailError(String message)
      : super(errorMessage: message, isError: true);
}