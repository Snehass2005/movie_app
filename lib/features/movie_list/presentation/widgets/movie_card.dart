import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/constants/app_constants.dart';
import 'package:movie_app/shared/config/dimens.dart';
import 'package:movie_app/shared/theme/text_styles.dart';
import 'package:movie_app/features/movie_list/data/models/MovieListDto.dart';

class MovieCard extends StatelessWidget {
  final MovieListDto movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Dimens.spacing_8,
        vertical: Dimens.spacing_8,
      ),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: movie.poster.isNotEmpty
              ? movie.poster
              : AppConstants.noPosterUrl,
          width: Dimens.thumbnailSize,
          fit: BoxFit.cover,
          placeholder: (context, url) => const SizedBox(
            width: Dimens.thumbnailSize,
            height: Dimens.thumbnailSize,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (context, url, error) =>
          const Icon(Icons.broken_image, size: Dimens.thumbnailSize),
        ),
        title: Text(movie.title, style: AppTextStyles.openSansRegular16),
        subtitle: Text('Year: ${movie.year}',
            style: AppTextStyles.openSansRegular14),
        onTap: () {
          context.goNamed(
            'detail',
            pathParameters: {'imdbID': movie.imdbID},
          );
        },
      ),
    );
  }
}