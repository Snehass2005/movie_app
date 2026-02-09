import 'dart:convert';
import 'package:hive/hive.dart';

part 'wishlist_item_model.g.dart';

WishlistItemModel wishlistItemModelFromJson(String str) =>
    WishlistItemModel.fromJson(json.decode(str));

String wishlistItemModelToJson(WishlistItemModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 34)
class WishlistItemModel {
  @HiveField(0)
  String imdbID;

  @HiveField(1)
  String title;

  @HiveField(2)
  String poster;

  WishlistItemModel({
    required this.imdbID,
    required this.title,
    required this.poster,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      poster: json['Poster'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imdbID'] = imdbID;
    map['Title'] = title;
    map['Poster'] = poster;
    return map;
  }
}