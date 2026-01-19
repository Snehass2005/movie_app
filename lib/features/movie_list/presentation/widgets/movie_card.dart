import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:movie_app/shared/config/dimens.dart';
import 'package:movie_app/shared/theme/text_styles.dart';
import 'package:movie_app/features/movie_list/domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Dimens.spacing_8,
        vertical: Dimens.spacing_8,
      ), // ✅ use Dimens
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: movie.posterUrl.isNotEmpty
              ? movie.posterUrl
              : 'https://via.placeholder.com/50?text=No+Image',
          width: Dimens.thumbnailSize, // ✅ use Dimens
          fit: BoxFit.cover,
          placeholder: (context, url) => const SizedBox(
            width: Dimens.thumbnailSize,
            height: Dimens.thumbnailSize,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (context, url, error) =>
          const Icon(Icons.broken_image, size: Dimens.thumbnailSize),
        ),
        title: Text(movie.title, style: AppTextStyles.openSansRegular16), // ✅ style
        subtitle: Text('${'year'.tr}: ${movie.year}',
            style: AppTextStyles.openSansRegular14), // ✅ style
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