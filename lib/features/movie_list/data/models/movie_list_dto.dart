import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/movie.dart';

class MovieListDto {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;

  MovieListDto({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.poster,
  });

  factory MovieListDto.fromJson(Map<String, dynamic> json) {
    final posterUrl = (json['Poster'] == null || json['Poster'] == 'N/A')
        ? AppConstants.noPosterUrl
        : json['Poster'];

    return MovieListDto(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
      poster: posterUrl,
    );
  }

  /// ✅ Map DTO → Entity
  Movie toEntity() {
    return Movie(
      imdbID: imdbID,
      title: title,
      year: year,
      type: type,
      posterUrl: poster,
    );
  }
}