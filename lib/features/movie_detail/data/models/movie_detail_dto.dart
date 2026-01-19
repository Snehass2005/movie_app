import '../../domain/entities/movie_detail.dart';

class MovieDetailDto {
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String poster;
  final String imdbRating;
  final String imdbID;
  final String type;

  // ✅ Proper unnamed constructor
  const MovieDetailDto({
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.imdbRating,
    required this.imdbID,
    required this.type,
  });

  factory MovieDetailDto.fromJson(Map<String, dynamic> json) {
    return MovieDetailDto(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      rated: json['Rated'] ?? '',
      released: json['Released'] ?? '',
      runtime: json['Runtime'] ?? '',
      genre: json['Genre'] ?? '',
      director: json['Director'] ?? '',
      writer: json['Writer'] ?? '',
      actors: json['Actors'] ?? '',
      plot: json['Plot'] ?? '',
      language: json['Language'] ?? '',
      country: json['Country'] ?? '',
      awards: json['Awards'] ?? '',
      poster: (json['Poster'] == null || json['Poster'] == 'N/A')
          ? 'https://via.placeholder.com/300x450?text=No+Poster'
          : json['Poster'],
      imdbRating: json['imdbRating'] ?? 'N/A',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
    );
  }

  /// ✅ Map DTO → Entity
  MovieDetail toEntity() {
    return MovieDetail(
      imdbID: imdbID,
      title: title,
      year: year,
      rated: rated,
      released: released,
      runtime: runtime,
      genre: genre,
      director: director,
      writer: writer,
      actors: actors,
      plot: plot,
      language: language,
      country: country,
      awards: awards,
      posterUrl: poster,
      imdbRating: imdbRating,
      type: type,
    );
  }
}