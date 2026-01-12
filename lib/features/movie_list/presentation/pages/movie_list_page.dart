import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/core/utils/debouncer.dart'; // ✅ Debouncer
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_detail/data/models/movie_detail_dto.dart';
import 'package:movie_app/features/movie_list/presentation/widgets/ranked_movie_card.dart';
import 'package:movie_app/shared/theme/app_colors.dart';
import 'package:movie_app/shared/config/dimens.dart';
import 'package:movie_app/shared/theme/text_styles.dart';
import '../cubit/movie_list_cubit.dart';

class MovieListPage extends StatefulWidget {
  final MovieListCubit cubit;
  final GetMovieDetailUseCase getMovieDetailUseCase;

  const MovieListPage({
    super.key,
    required this.cubit,
    required this.getMovieDetailUseCase,
  });

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late final ScrollController _scrollController;
  late final Debouncer _debouncer; // ✅ Debouncer instance
  String currentQuery = "batman";

  @override
  void initState() {
    super.initState();
    widget.cubit.loadMovies(query: currentQuery);

    _scrollController = ScrollController();
    _debouncer = Debouncer(milliseconds: 500); // ✅ initialize

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (widget.cubit.searchedMovies.isNotEmpty) {
          widget.cubit.loadMoreSearch(currentQuery);
        } else {
          widget.cubit.loadMoreMovies(currentQuery);
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
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Movies', style: AppTextStyles.openSansBold20),
          backgroundColor: AppColors.colorSecondary,
          elevation: Dimens.elevation_2,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimens.spacing_8),
              child: TextField(
                style: AppTextStyles.openSansRegular16,
                decoration: const InputDecoration(
                  hintText: 'Search movies...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    currentQuery = query;
                    widget.cubit.search(query);
                  }
                },
                onChanged: (query) {
                  if (query.trim().length > 2) {
                    currentQuery = query;
                    _debouncer.run(() {
                      widget.cubit.search(query);
                    });
                  }
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
                    final allMovies = [
                      ...state.searchedMovies,
                      ...state.defaultMovies
                    ];
                    final uniqueMovies = {
                      for (var m in allMovies) m.imdbID: m
                    }.values.toList();

                    if (uniqueMovies.isEmpty) {
                      return Center(
                        child: Text('No movies found.',
                            style: AppTextStyles.openSansRegular14),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: uniqueMovies.length,
                      itemBuilder: (context, index) {
                        final movie = uniqueMovies[index];
                        return FutureBuilder<Either<AppException, MovieDetailDto>>(
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
                                    (detail) => RankedMovieCard(
                                  movie: detail,
                                  rank: index + 1,
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
      ),
    );
  }
}