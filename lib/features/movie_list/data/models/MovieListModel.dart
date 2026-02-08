class MovieListModel {
  final String imdbID;
  final String title;
  final String year;
  final String type;
  final String poster;

  const MovieListModel({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.type,
    required this.poster,
  });

  factory MovieListModel.fromJson(Map<String, dynamic> json) {
    return MovieListModel(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      type: json['Type'] ?? '',
      poster: json['Poster'] ?? '',
    );
  }
}