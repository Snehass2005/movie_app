import 'package:flutter/material.dart';
import 'package:movie_app/features/movie_detail/domain/usecases/get_movie_detail_usecases.dart';
import '../../data/models/movie_list_dto.dart';
import '../../../movie_detail/presentation/pages/movie_detail_page.dart';

class MovieCard extends StatelessWidget {
  final MovieListDto movie;
  final GetMovieDetailUseCase getMovieDetailUseCase;

  const MovieCard({
    super.key,
    required this.movie,
    required this.getMovieDetailUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Image.network(
          movie.poster.isNotEmpty ? movie.poster : 'https://via.placeholder.com/50',
          width: 50,
          fit: BoxFit.cover,
        ),
        title: Text(movie.title),
        subtitle: Text(movie.year),
        onTap: () {
          // ✅ Navigate to MovieDetailPage with imdbID
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailPage(imdbID: movie.imdbID),
            ),
          );
        },
      ),
    );
  }
}