import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/constants/app_constants.dart';
import 'package:movie_app/shared/config/dimens.dart';
import 'package:movie_app/shared/theme/text_styles.dart';
import 'package:movie_app/features/movie_detail/domain/entities/movie_detail.dart';

class MovieDetailView extends StatelessWidget {
  final MovieDetail detail;

  const MovieDetailView({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimens.spacing_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: detail.posterUrl.isNotEmpty
                  ? detail.posterUrl
                  : AppConstants.noPosterUrl,
              height: Dimens.imageLarge,
              fit: BoxFit.cover,
              placeholder: (context, url) => SizedBox(
                height: Dimens.imageLarge,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) =>
              Icon(Icons.broken_image, size: Dimens.iconLarge),
            ),
          ),
          const SizedBox(height: Dimens.spacing_16),
          Text(detail.title, style: Theme.of(context).textTheme.titleLarge),
          Text('${detail.year} • ${detail.runtime} • ${detail.genre}',
              style: AppTextStyles.openSansRegular14),
          const SizedBox(height: Dimens.spacing_8),
          Text('${'director'.tr}: ${detail.director}',
              style: AppTextStyles.openSansRegular14),
          Text('${'actors'.tr}: ${detail.actors}',
              style: AppTextStyles.openSansRegular14),
          const SizedBox(height: Dimens.spacing_16),
          Text(detail.plot, style: AppTextStyles.openSansRegular14),
          const SizedBox(height: Dimens.spacing_16),
          Text('${'rating'.tr}: ${detail.imdbRating}',
              style: AppTextStyles.openSansRegular14),
        ],
      ),
    );
  }
}