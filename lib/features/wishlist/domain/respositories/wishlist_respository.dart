import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/wishlist/data/models/wishlist_item_model.dart';

abstract class WishlistRepository {
  Future<Either<AppException, List<WishlistItemModel>>> getWishlist();

  Future<Either<AppException, bool>> toggleWishlist(
      WishlistItemModel item);
}