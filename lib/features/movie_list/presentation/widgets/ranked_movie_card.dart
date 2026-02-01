import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/constants/routes.dart';
import 'package:movie_app/features/movie_list/data/models/MovieListDto.dart'; // ✅ use MovieListDto
import 'package:movie_app/shared/config/dimens.dart';
import 'package:movie_app/shared/theme/app_colors.dart';
import 'package:movie_app/shared/theme/text_styles.dart';

class RankedMovieCard extends StatelessWidget {
  final MovieListDto movie;
  final int rank;

  const RankedMovieCard({
    super.key,
    required this.movie,
    required this.rank,
  });

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return AppColors.colorPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('${RoutesName.movieDetail}/${movie.imdbID}');
      },
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: Dimens.standard_12,
              vertical: Dimens.standard_8,
            ),
            elevation: Dimens.elevation_4,
            child: Padding(
              padding: const EdgeInsets.all(Dimens.standard_12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimens.standard_8),
                    child: CachedNetworkImage(
                      imageUrl: movie.poster,
                      width: Dimens.standard_80,
                      height: Dimens.standard_120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(
                        width: Dimens.standard_80,
                        height: Dimens.standard_120,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.broken_image,
                        size: Dimens.standard_80,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimens.standard_12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: AppTextStyles.openSansBold16,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Dimens.standard_4),
                        Text(
                          '${movie.year} • ${movie.type}',
                          style: AppTextStyles.openSansRegular14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (rank <= 3)
            Positioned(
              top: 0,
              left: 0,
              child: CircleAvatar(
                backgroundColor: _rankColor(rank),
                radius: Dimens.standard_12,
                child: Text(
                  '$rank',
                  style: AppTextStyles.openSansBold12.copyWith(
                    color: AppColors.colorWhite,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}