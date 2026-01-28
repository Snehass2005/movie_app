import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/core/exceptions/exception_handler_mixin.dart';
import 'package:movie_app/features/movie_detail/data/models/movie_detail_dto.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> with ExceptionHandlerMixin {
  final GetMovieDetailUseCase _getMovieDetailUseCase;

  MovieDetailCubit(this._getMovieDetailUseCase) : super(const MovieDetailInitial());

  Future<void> fetchDetail(String imdbID) async {
    emit(const MovieDetailLoading());

    try {
      final result = await _getMovieDetailUseCase.getMovieDetail(imdbID: imdbID);

      result.onLeft((failure) {
        emit(MovieDetailError(getErrorMessage(failure)));
      });

      result.onRight((detail) {
        emit(MovieDetailSuccess(detail)); // ✅ detail is MovieDetailDto now
      });
    } catch (e) {
      emit(MovieDetailError(getErrorMessage(e)));
    }
  }
}