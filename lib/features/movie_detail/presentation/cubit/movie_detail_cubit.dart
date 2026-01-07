import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_detail/data/models/movie_detail_dto.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final GetMovieDetailUseCase _getMovieDetailUseCase;

  MovieDetailCubit(this._getMovieDetailUseCase)
      : super(const MovieDetailLoaded());

  Future<void> fetchDetail(String imdbID) async {
    final currentState = state;
    if (currentState is MovieDetailLoaded) {
      emit(currentState.copyWith(isLoading: true));
      try {
        final result = await _getMovieDetailUseCase(imdbID);
        result.fold(
              (failure) => emit(currentState.copyWith(
            errorMessage: failure.message,
            isLoading: false,
            isError: true,
          )),
              (detail) => emit(MovieDetailSuccess(detail)),
        );
      } catch (e) {
        emit(currentState.copyWith(
          errorMessage: 'Failed to fetch movie detail',
          isLoading: false,
          isError: true,
        ));
      }
    }
  }

  void resetError() {
    final currentState = state;
    if (currentState is MovieDetailLoaded) {
      emit(currentState.copyWith(isLoading: false, isError: false));
    }
  }
}