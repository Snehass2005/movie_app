import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_app/lang/app_localizations.dart';
import '../../data/models/movie_detail_dto.dart';

class MovieDetailView extends StatelessWidget {
  final MovieDetailDto? detail;

  const MovieDetailView({super.key, this.detail});

  @override
  Widget build(BuildContext context) {
    if (detail == null) {
      return Center(child: Text(AppLocalizations.t('no_movies'))); // ✅ localized
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: detail!.poster.isNotEmpty
                  ? detail!.poster
                  : 'https://via.placeholder.com/150',
              height: 250,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(
                height: 250,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) =>
              const Icon(Icons.broken_image, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          Text(detail!.title, style: Theme.of(context).textTheme.titleLarge),
          Text('${detail!.year} • ${detail!.runtime} • ${detail!.genre}'),
          const SizedBox(height: 8),
          Text('${AppLocalizations.t('director')}: ${detail!.director}'),
          Text('${AppLocalizations.t('actors')}: ${detail!.actors}'),
          const SizedBox(height: 16),
          Text(detail!.plot),
          const SizedBox(height: 16),
          Text('${AppLocalizations.t('rating')}: ${detail!.imdbRating}'),
        ],
      ),
    );
  }
}