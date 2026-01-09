import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import 'package:movie_app/features/movie_detail/data/models/movie_detail_dto.dart';
import 'package:movie_app/features/movie_list/presentation/widgets/ranked_movie_card.dart';
import 'package:movie_app/shared/theme/app_colors.dart';
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
  @override
  void initState() {
    super.initState();
    // ✅ Load default movies immediately
    widget.cubit.loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Movies'),
            backgroundColor: AppColors.colorSecondary),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search movies...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    widget.cubit.search(query);
                  }
                },
                onChanged: (query) {
                  if (query.trim().length > 2) {
                    widget.cubit.search(query);
                  }
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<MovieListCubit, MovieListState>(
                builder: (context, state) {
                  if (state.isLoading) {
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
                      return const Center(child: Text('No movies found.'));
                    }

                    return ListView.builder(
                      itemCount: uniqueMovies.length,
                      itemBuilder: (context, index) {
                        final movie = uniqueMovies[index];
                        return FutureBuilder<Either<AppException, MovieDetailDto>>(
                          future: widget.getMovieDetailUseCase.call(movie.imdbID),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const ListTile(title: Text('Loading details...'));
                            } else if (snapshot.hasError) {
                              return ListTile(
                                title: Text(movie.title),
                                subtitle: const Text('Error loading details'),
                              );
                            } else if (snapshot.hasData) {
                              return snapshot.data!.fold(
                                    (failure) => ListTile(
                                  title: Text(movie.title),
                                  subtitle: Text('Error: ${failure.message}'),
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
                    return Center(child: Text(state.errorMessage));
                  }
                  return const Center(child: Text('Search for a movie'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}