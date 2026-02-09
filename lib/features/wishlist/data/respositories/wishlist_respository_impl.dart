import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/wishlist/data/datasources/wishlist_local_datasource.dart';
import 'package:movie_app/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:movie_app/features/wishlist/domain/respositories/wishlist_respository.dart';


class WishlistRepositoryImpl extends WishlistRepository {
  final WishlistLocalDataSource _localDataSource;

  WishlistRepositoryImpl(this._localDataSource);

  @override
  Future<Either<AppException, List<WishlistItemModel>>> getWishlist() {
    return _localDataSource.getWishlist();
  }

  @override
  Future<Either<AppException, bool>> toggleWishlist(WishlistItemModel item) {
    return _localDataSource.toggleWishlist(item);
  }
}