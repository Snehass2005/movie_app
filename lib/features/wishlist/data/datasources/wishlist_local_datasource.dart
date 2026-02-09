import 'package:hive/hive.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import '../models/wishlist_item_model.dart';

abstract class WishlistLocalDataSource {
  Future<Either<AppException, List<WishlistItemModel>>> getWishlist();
  Future<Either<AppException, bool>> toggleWishlist(WishlistItemModel item);
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  static const String boxName = 'wishlist';

  Future<Box<WishlistItemModel>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<WishlistItemModel>(boxName);
    }
    return Hive.box<WishlistItemModel>(boxName);
  }

  @override
  Future<Either<AppException, List<WishlistItemModel>>> getWishlist() async {
    try {
      final box = await _openBox();
      return Right(box.values.toList());
    } catch (e) {
      print('WishlistLocalDataSource.getWishlist error: $e');
      return Left(AppException.network(e.toString()));
    }
  }

  @override
  Future<Either<AppException, bool>> toggleWishlist(WishlistItemModel item) async {
    try {
      final box = await _openBox();
      if (box.containsKey(item.imdbID)) {
        await box.delete(item.imdbID);
        return Right(false); // removed
      } else {
        await box.put(item.imdbID, item);
        return Right(true); // added
      }
    } catch (e) {
      print('WishlistLocalDataSource.toggleWishlist error: $e');
      return Left(AppException.network(e.toString()));
    }
  }
}