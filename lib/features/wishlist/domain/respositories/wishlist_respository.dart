import 'package:movie_app/features/wishlist/data/models/wishlist_item_dto.dart';

abstract class WishlistRepository {
  Future<List<WishlistItemDto>> getWishlist();
  Future<void> toggleWishlist(WishlistItemDto item);
}