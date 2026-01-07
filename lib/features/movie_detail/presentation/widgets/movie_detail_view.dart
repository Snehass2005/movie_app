import 'package:flutter/material.dart';
import '../../data/models/movie_detail_dto.dart';

class MovieDetailView extends StatelessWidget {
  final MovieDetailDto? detail; // ✅ allow nullable

  const MovieDetailView({super.key, this.detail});

  @override
  Widget build(BuildContext context) {
    if (detail == null) {
      return const Center(child: Text('No detail available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              detail!.poster.isNotEmpty
                  ? detail!.poster
                  : 'https://via.placeholder.com/150',
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(detail!.title, style: Theme.of(context).textTheme.titleLarge),
          Text('${detail!.year} • ${detail!.runtime} • ${detail!.genre}'),
          const SizedBox(height: 8),
          Text('Director: ${detail!.director}'),
          Text('Actors: ${detail!.actors}'),
          const SizedBox(height: 16),
          Text(detail!.plot),
          const SizedBox(height: 16),
          Text('IMDb Rating: ${detail!.imdbRating}'),
        ],
      ),
    );
  }
}