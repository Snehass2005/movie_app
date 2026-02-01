import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/constants/routes.dart';
import 'package:movie_app/core/dependency_injection/injector.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_detail/presentation/cubit/movie_detail_cubit.dart';
import 'package:movie_app/features/movie_detail/presentation/cubit/movie_detail_state.dart'; // ✅ import the unified state
import 'package:movie_app/features/movie_detail/presentation/widgets/movie_detail_view.dart';
import 'package:movie_app/shared/config/dimens.dart';
import 'package:movie_app/shared/theme/app_colors.dart';
import 'package:movie_app/shared/theme/text_styles.dart';

class MovieDetailPage extends StatefulWidget {
  final String imdbID;

  const MovieDetailPage({super.key, required this.imdbID});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late MovieDetailCubit _movieDetailCubit;

  @override
  void initState() {
    super.initState();
    final getMovieDetailUseCase = injector<GetMovieDetailUseCase>();
    _movieDetailCubit = MovieDetailCubit(getMovieDetailUseCase);
    _movieDetailCubit.fetchDetail(widget.imdbID);
  }

  @override
  void dispose() {
    _movieDetailCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieDetailCubit>(
      create: (_) => _movieDetailCubit,
      child: Scaffold(
        backgroundColor: AppColors.colorSecondary,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(RoutesName.defaultPath),
          ),
          title: Text('Movie Detail', style: AppTextStyles.openSansBold20),
          centerTitle: true,
          backgroundColor: AppColors.colorSecondary,
          elevation: Dimens.elevation_2,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.spacing_16),
              child: BlocConsumer<MovieDetailCubit, MovieDetailState>(
                listener: (context, state) {
                  if (state.isFailure && state.message.isNotEmpty) {
                    _showErrorSnackBar(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.isSuccess && state.detail != null) {
                    return Card(
                      elevation: Dimens.elevation_4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.radius_16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimens.spacing_16),
                        child: MovieDetailView(detail: state.detail!),
                      ),
                    );
                  } else if (state.isFailure) {
                    return Center(
                      child: Text(
                        state.message,
                        style: AppTextStyles.openSansRegular14,
                      ),
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
    log('ERROR ----- $message');
  }
}