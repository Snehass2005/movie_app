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
import '../cubit/movie_list_state.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late MovieListCubit _movieListCubit;
  late final ScrollController _scrollController;
  late final TextEditingController searchController;
  late final TextEditingController yearController;

  String currentQuery = "batman";
  String? currentYear;
  bool isSearchMode = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    searchController = TextEditingController();
    yearController = TextEditingController();

    final searchMoviesUseCase = injector<SearchMoviesUseCase>();
    final getMovieDetailUseCase = injector<GetMovieDetailUseCase>();
    _movieListCubit = MovieListCubit(searchMoviesUseCase, getMovieDetailUseCase);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        isSearchMode
            ? _movieListCubit.loadMoreSearch(currentQuery)
            : _movieListCubit.loadMoreMovies(currentQuery);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    yearController.dispose();
    _movieListCubit.close();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieListCubit>(
      create: (_) => _movieListCubit..loadMovies(query: currentQuery, year: currentYear),
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
                if (state.isFailure && state.message.isNotEmpty) {
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
                            yearController.clear();
                            currentQuery = "batman";
                            currentYear = null;
                            isSearchMode = false;
                            _movieListCubit.loadMovies(query: currentQuery, year: currentYear);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onSubmitted: (value) {
                        currentQuery = value.isEmpty ? "batman" : value;
                        currentYear = yearController.text.isEmpty ? null : yearController.text;
                        isSearchMode = currentQuery != "batman";
                        isSearchMode
                            ? _movieListCubit.search(currentQuery, year: currentYear)
                            : _movieListCubit.loadMovies(query: currentQuery, year: currentYear);
                      },
                    ),
                    const SizedBox(height: Dimens.standard_16),
                    TextField(
                      controller: yearController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter year',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onSubmitted: (_) {
                        currentYear = yearController.text.isEmpty ? null : yearController.text;
                        isSearchMode
                            ? _movieListCubit.search(currentQuery, year: currentYear)
                            : _movieListCubit.loadMovies(query: currentQuery, year: currentYear);
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
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.isSuccess) {
      final moviesToShow =
      isSearchMode ? state.searchedMovies : state.defaultMovies;

      if (moviesToShow.isEmpty) {
        return Center(
          child: Text('No movies found.', style: AppTextStyles.openSansRegular14),
        );
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: moviesToShow.length + 1, // ✅ add one extra slot
        itemBuilder: (context, index) {
          if (index < moviesToShow.length) {
            final movie = moviesToShow[index];
            return GestureDetector(
              onTap: () {
                context.go('${RoutesName.movieDetail}/${movie.imdbID}');
              },
              child: RankedMovieCard(movie: movie, rank: index + 1),
            );
          } else {
            // ✅ Loader at the bottom during pagination
            if (state.isPaginatingDefault || state.isPaginatingSearch) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return const SizedBox.shrink(); // nothing if not loading
            }
          }
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