import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:movie_app/core/constants/routes.dart';
import 'package:movie_app/core/dependency_injection/injector.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
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
  late final TextEditingController searchController;

  String currentQuery = "batman";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    searchController = TextEditingController();

    final searchMoviesUseCase = injector<SearchMoviesUseCase>();
    final getMovieDetailUseCase = injector<GetMovieDetailUseCase>();
    _movieListCubit = MovieListCubit(searchMoviesUseCase, getMovieDetailUseCase);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (currentQuery == "batman") {
          _movieListCubit.loadMoreMovies(currentQuery);
        } else {
          _movieListCubit.loadMoreSearch(currentQuery);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
                if (state is MovieListError) {
                  _showErrorSnackBar(context, state.message);
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
                            _movieListCubit.loadMovies(query: currentQuery);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onChanged: (value) {
                        currentQuery = value.isEmpty ? "batman" : value;
                        if (currentQuery == "batman") {
                          _movieListCubit.loadMovies(query: currentQuery);
                        } else {
                          _movieListCubit.search(currentQuery); // ✅ search flow
                        }
                      },
                    ),
                    const SizedBox(height: Dimens.standard_16),
                    Expanded(child: _buildMovieList(state)),
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
    if (state is MovieListLoading) {
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
          final detail = state.movieDetails[movie.imdbID];

          if (detail == null) {
            _movieListCubit.loadMovieDetail(movie.imdbID); // ✅ preload detail
            return ListTile(
              title: Text(movie.title, style: AppTextStyles.openSansRegular16),
              subtitle: const Text('Loading details...'),
            );
          }

          return GestureDetector(
            onTap: () {
              context.push('${RoutesName.movieDetail}/${detail.imdbID}');
            },
            child: RankedMovieCard(movie: detail, rank: index + 1),
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