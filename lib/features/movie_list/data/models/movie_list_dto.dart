class MovieListDto {
  final String imdbID;
  final String title;
  final String year;
  final String type;
  final String poster;

  const MovieListDto({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.type,
    required this.poster,
  });

  factory MovieListDto.fromJson(Map<String, dynamic> json) {
    return MovieListDto(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      type: json['Type'] ?? '',
      poster: json['Poster'] ?? '',
    );
  }
}