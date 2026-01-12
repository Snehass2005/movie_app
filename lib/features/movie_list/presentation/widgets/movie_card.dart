import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/lang/app_localizations.dart';
import '../../data/models/movie_list_dto.dart';

class MovieCard extends StatelessWidget {
  final MovieListDto movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: movie.poster.isNotEmpty
              ? movie.poster
              : 'https://via.placeholder.com/50',
          width: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) => const SizedBox(
            width: 50,
            height: 50,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (context, url, error) =>
          const Icon(Icons.broken_image, size: 50),
        ),
        title: Text(movie.title),
        subtitle: Text('${AppLocalizations.t('year')}: ${movie.year}'), // ✅ localized
        onTap: () {
          context.go('/detail/${movie.imdbID}');
        },
      ),
    );
  }
}