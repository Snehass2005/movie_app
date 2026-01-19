import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/constants/routes.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/core/utils/debouncer.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:movie_app/features/movie_list/presentation/widgets/ranked_movie_card.dart';
import 'package:movie_app/shared/theme/app_colors.dart';
import 'package:movie_app/shared/config/dimens.dart';
import 'package:movie_app/shared/theme/text_styles.dart';
import '../cubit/movie_list_cubit.dart';
import 'package:movie_app/core/dependency_injection/injector.dart';

class MovieListPage extends StatefulWidget {
  final GetMovieDetailUseCase getMovieDetailUseCase;

  const MovieListPage({
    super.key,
    required this.getMovieDetailUseCase,
  });

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late final ScrollController _scrollController;
  late final Debouncer _debouncer;
  String currentQuery = "batman";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _debouncer = Debouncer(milliseconds: 500);

    _scrollController.addListener(() {
      final cubit = context.read<MovieListCubit>();
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (cubit.searchedMovies.isNotEmpty) {
          cubit.loadMoreSearch(currentQuery);
        } else {
          cubit.loadMoreMovies(currentQuery);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieListCubit>(
      create: (_) => injector<MovieListCubit>()..loadMovies(query: currentQuery),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Movies', style: AppTextStyles.openSansBold20),
              backgroundColor: AppColors.colorSecondary,
              elevation: Dimens.elevation_2,
              actions: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    currentQuery = "batman";
                    context.read<MovieListCubit>().resetSearch();
                    context.read<MovieListCubit>().loadMovies(query: currentQuery);
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimens.spacing_16),
                  child: TextField(
                    style: AppTextStyles.openSansRegular16,
                    decoration: const InputDecoration(
                      hintText: 'Search movies...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (query) {
                      currentQuery = query;
                      context.read<MovieListCubit>().handleSearch(query);
                    },
                    onChanged: (query) {
                      currentQuery = query;
                      _debouncer.run(() {
                        context.read<MovieListCubit>().handleSearch(query);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: BlocBuilder<MovieListCubit, MovieListState>(
                    builder: (context, state) {
                      if (state.isLoading &&
                          state.defaultMovies.isEmpty &&
                          state.searchedMovies.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is MovieListSuccess) {
                        final moviesToShow = state.searchedMovies.isNotEmpty
                            ? state.searchedMovies
                            : state.defaultMovies;

                        if (moviesToShow.isEmpty) {
                          return Center(
                            child: Text('No movies found.',
                                style: AppTextStyles.openSansRegular14),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: moviesToShow.length,
                          itemBuilder: (context, index) {
                            final movie = moviesToShow[index];
                            return FutureBuilder<Either<AppException, MovieDetail>>(
                              future: widget.getMovieDetailUseCase.call(movie.imdbID),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ListTile(
                                    title: Text('Loading details...',
                                        style: AppTextStyles.openSansRegular14),
                                  );
                                } else if (snapshot.hasError) {
                                  return ListTile(
                                    title: Text(movie.title,
                                        style: AppTextStyles.openSansRegular16),
                                    subtitle: Text('Error loading details',
                                        style: AppTextStyles.openSansRegular14),
                                  );
                                } else if (snapshot.hasData) {
                                  return snapshot.data!.fold(
                                        (failure) => ListTile(
                                      title: Text(movie.title,
                                          style: AppTextStyles.openSansRegular16),
                                      subtitle: Text('Error: ${failure.message}',
                                          style: AppTextStyles.openSansRegular14),
                                    ),
                                        (detail) => GestureDetector(
                                      onTap: () {
                                        context.push(
                                            '${RoutesName.movieDetail}/${detail.imdbID}');
                                      },
                                      child: RankedMovieCard(
                                        movie: detail,
                                        rank: index + 1,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            );
                          },
                        );
                      } else if (state.isError) {
                        return Center(
                          child: Text(state.errorMessage,
                              style: AppTextStyles.openSansRegular14),
                        );
                      }
                      return Center(
                        child: Text('Search for a movie',
                            style: AppTextStyles.openSansRegular14),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}