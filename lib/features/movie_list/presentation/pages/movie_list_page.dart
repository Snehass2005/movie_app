import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:movie_app/core/constants/routes.dart';
import 'package:movie_app/core/dependency_injection/injector.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/core/utils/debouncer.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:movie_app/features/movie_list/domain/usecases/movie_search_usecases.dart';
import 'package:movie_app/features/movie_list/presentation/widgets/ranked_movie_card.dart';
import 'package:movie_app/shared/theme/app_colors.dart';
import 'package:movie_app/shared/config/dimens.dart';
import 'package:movie_app/shared/theme/text_styles.dart';

import '../cubit/movie_list_cubit.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late MovieListCubit _movieListCubit;
  late final ScrollController _scrollController;
  late final Debouncer _debouncer;
  late final TextEditingController searchController;

  String currentQuery = "batman";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _debouncer = Debouncer(milliseconds: 500);
    searchController = TextEditingController();

    final searchMoviesUseCase = injector<SearchMoviesUseCase>();
    final getMovieDetailUseCase = injector<GetMovieDetailUseCase>();
    _movieListCubit = MovieListCubit(searchMoviesUseCase, getMovieDetailUseCase);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_movieListCubit.searchedMovies.isNotEmpty) {
          _movieListCubit.loadMoreSearch(currentQuery);
        } else {
          _movieListCubit.loadMoreMovies(currentQuery);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debouncer.cancel();
    searchController.dispose();
    _movieListCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieListCubit>(
      create: (_) => _movieListCubit..loadMovies(query: currentQuery),
      child: Scaffold(
        backgroundColor: AppColors.appBackGround,
        appBar: AppBar(
          title: Text('Movies', style: AppTextStyles.openSansBold20),
          backgroundColor: AppColors.colorSecondary,
          elevation: Dimens.elevation_2,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.spacing_16),
            child: BlocConsumer<MovieListCubit, MovieListState>(
              listener: (context, state) {
                if (state.isError && state.errorMessage.isNotEmpty) {
                  _showErrorSnackBar(context, state.errorMessage);
                  _movieListCubit.resetError();
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search movies...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            currentQuery = "batman";
                            _movieListCubit.resetSearch();
                            _movieListCubit.loadMovies(query: currentQuery);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onChanged: (value) {
                        _debouncer.run(() {
                          currentQuery = value.isEmpty ? "batman" : value;
                          _movieListCubit.loadMovies(query: currentQuery);
                        });
                      },
                    ),
                    const SizedBox(height: Dimens.standard_16),
                    Expanded(
                      child: _buildMovieList(state),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieList(MovieListState state) {
    if (state.isLoading &&
        state.defaultMovies.isEmpty &&
        state.searchedMovies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is MovieListSuccess) {
      final moviesToShow =
      state.searchedMovies.isNotEmpty ? state.searchedMovies : state.defaultMovies;

      if (moviesToShow.isEmpty) {
        return Center(
          child: Text('No movies found.', style: AppTextStyles.openSansRegular14),
        );
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: moviesToShow.length,
        itemBuilder: (context, index) {
          final movie = moviesToShow[index];
          return FutureBuilder<Either<AppException, MovieDetail>>(
            future: injector<GetMovieDetailUseCase>().getMovieDetail(imdbID: movie.imdbID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  title: Text('Loading details...', style: AppTextStyles.openSansRegular14),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  title: Text(movie.title, style: AppTextStyles.openSansRegular16),
                  subtitle: Text('Error loading details',
                      style: AppTextStyles.openSansRegular14),
                );
              } else if (snapshot.hasData) {
                return snapshot.data!.fold(
                      (failure) => ListTile(
                    title: Text(movie.title, style: AppTextStyles.openSansRegular16),
                    subtitle: Text('Error: ${failure.message}',
                        style: AppTextStyles.openSansRegular14),
                  ),
                      (detail) => GestureDetector(
                    onTap: () {
                      context.push('${RoutesName.movieDetail}/${detail.imdbID}');
                    },
                    child: RankedMovieCard(movie: detail, rank: index + 1),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      );
    }
    return Center(
      child: Text('Search for a movie', style: AppTextStyles.openSansRegular14),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
    log('ERROR ----- $message');
  }
}