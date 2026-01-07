import 'package:flutter/material.dart';
import 'package:movie_app/features/movie_detail/data/models/movie_detail_dto.dart';
import 'package:movie_app/features/movie_detail/presentation/pages/movie_detail_page.dart'; // ✅ import your detail page

class RankedMovieCard extends StatelessWidget {
  final MovieDetailDto movie;
  final int rank;

  const RankedMovieCard({
    super.key,
    required this.movie,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // ✅ Navigate to detail page when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(imdbID: movie.imdbID),
          ),
        );
      },
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Poster image with fallback
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      movie.poster ?? '',
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // ✅ Movie details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title ?? 'Untitled',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rating: ${movie.imdbRating ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Country / Format: ${movie.country ?? 'N/A'} / ${movie.type ?? 'N/A'}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Director: ${movie.director ?? 'N/A'}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ✅ Rank badge for top 3
          if (rank <= 3)
            Positioned(
              top: 0,
              left: 0,
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 12,
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}