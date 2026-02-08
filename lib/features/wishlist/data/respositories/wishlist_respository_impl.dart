import 'package:movie_app/features/wishlist/domain/respositories/wishlist_respository.dart';

import '../datasources/wishlist_local_datasource.dart';
import '../models/wishlist_item_dto.dart';


class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl(this.localDataSource);

  @override
  Future<List<WishlistItemDto>> getWishlist() async {
    return localDataSource.getWishlist();
  }

  @override
  Future<void> toggleWishlist(WishlistItemDto item) async {
    await localDataSource.toggleWishlist(item);
  }
}