import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:movie_app/features/wishlist/domain/respositories/wishlist_respository.dart';


class WishlistUseCases {
  final WishlistRepository _wishlistRepository;

  const WishlistUseCases(this._wishlistRepository);

  Future<Either<AppException, List<WishlistItemModel>>> getWishlist() async {
    return _wishlistRepository.getWishlist();
  }

  Future<Either<AppException, bool>> toggleWishlist({
    required WishlistItemModel item,
  }) async {
    return _wishlistRepository.toggleWishlist(item);
  }
}