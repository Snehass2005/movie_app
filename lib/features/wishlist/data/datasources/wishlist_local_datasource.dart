import 'package:hive/hive.dart';
import '../models/wishlist_item_dto.dart';

class WishlistLocalDataSource {
  static const String boxName = 'wishlist';

  /// Ensure the box is opened before use
  Future<Box<WishlistItemDto>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<WishlistItemDto>(boxName);
    }
    return Hive.box<WishlistItemDto>(boxName);
  }

  /// Get all wishlist items
  Future<List<WishlistItemDto>> getWishlist() async {
    final box = await _openBox();
    return box.values.toList();
  }

  /// Toggle wishlist item (add/remove)
  Future<void> toggleWishlist(WishlistItemDto item) async {
    final box = await _openBox();
    if (box.containsKey(item.imdbID)) {
      await box.delete(item.imdbID);
    } else {
      await box.put(item.imdbID, item);
    }
  }
}