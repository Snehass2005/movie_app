import 'package:hive/hive.dart';

part 'wishlist_item_dto.g.dart';

@HiveType(typeId: 34)
class WishlistItemDto {
  @HiveField(0)
  final String imdbID;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String poster;

  const WishlistItemDto({
    required this.imdbID,
    required this.title,
    required this.poster,
  });

  factory WishlistItemDto.fromJson(Map<String, dynamic> json) {
    return WishlistItemDto(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      poster: json['Poster'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imdbID': imdbID,
      'Title': title,
      'Poster': poster,
    };
  }
}