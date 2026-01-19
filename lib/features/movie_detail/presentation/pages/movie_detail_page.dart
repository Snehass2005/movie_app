import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/constants/routes.dart';

import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_detail/presentation/cubit/movie_detail_cubit.dart';
import 'package:movie_app/features/movie_list/domain/usecases/movie_search_usecases.dart';
import 'package:movie_app/features/movie_list/presentation/cubit/movie_list_cubit.dart';
import 'package:movie_app/shared/config/dimens.dart';
import 'package:movie_app/shared/theme/app_colors.dart';
import 'package:movie_app/shared/theme/text_styles.dart';
import 'package:movie_app/features/movie_detail/presentation/widgets/movie_detail_view.dart';

class MovieDetailPage extends StatelessWidget {
  final String imdbID;

  const MovieDetailPage({super.key, required this.imdbID});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailCubit>(
          create: (_) {
            final cubit = MovieDetailCubit(GetIt.instance<GetMovieDetailUseCase>());
            cubit.fetchDetail(imdbID); // ✅ trigger fetch immediately
            return cubit;
          },
        ),
        BlocProvider<MovieListCubit>(
          create: (_) => MovieListCubit(
            GetIt.instance<SearchMoviesUseCase>(),
            GetIt.instance<GetMovieDetailUseCase>(),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.colorSecondary,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(RoutesName.defaultPath), // GoRouter back
          ),
          title: Text('Movie Detail', style: AppTextStyles.openSansBold20),
          centerTitle: true,
          backgroundColor: AppColors.colorSecondary,
          elevation: Dimens.elevation_2,
        ),
        body: Container(
          color: AppColors.colorSecondary,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.spacing_16), // ✅ Dimens
              child: BlocConsumer<MovieDetailCubit, MovieDetailState>(
                listener: (context, state) {
                  if (state is MovieDetailSuccess) {
                    context.read<MovieListCubit>().loadMovies();
                  } else if (state.isError) {
                    _showErrorSnackBar(context, state.errorMessage);
                    context.read<MovieDetailCubit>().resetError();
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MovieDetailSuccess) {
                    return Card(
                      elevation: Dimens.elevation_4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.radius_16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimens.spacing_16),
                        child: MovieDetailView(detail: state.detail),
                      ),
                    );
                  } else if (state.isError) {
                    return Center(
                      child: Text(state.errorMessage,
                          style: AppTextStyles.openSansRegular14),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.openSansRegular14),
        backgroundColor: AppColors.colorSecondary,
      ),
    );
  }
}