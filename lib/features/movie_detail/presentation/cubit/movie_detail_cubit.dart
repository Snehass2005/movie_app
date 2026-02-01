import 'package:bloc/bloc.dart';
import 'package:movie_app/core/exceptions/exception_handler_mixin.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';

import 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> with ExceptionHandlerMixin {
  final GetMovieDetailUseCase _getMovieDetailUseCase;

  MovieDetailCubit(this._getMovieDetailUseCase) : super(const MovieDetailState());

  Future<void> fetchDetail(String imdbID) async {
    emit(state.copyWith(isLoading: true, message: ''));

    try {
      final result = await _getMovieDetailUseCase.getMovieDetail(imdbID: imdbID);

      result.onLeft((failure) {
        emit(state.copyWith(
          message: getErrorMessage(failure),
          isLoading: false,
          isFailure: true,
        ));
      });

      result.onRight((detail) {
        emit(state.copyWith(
          detail: detail,
          isLoading: false,
          isSuccess: true,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        message: getErrorMessage(e),
        isLoading: false,
        isFailure: true,
      ));
    }
  }

  /// Reset state back to initial
  void clearState() {
    emit(const MovieDetailState());
  }

  /// Reset just the error after showing toast/snackbar
  void resetError() {
    emit(state.copyWith(isFailure: false, message: ''));
  }
}