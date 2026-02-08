
import 'package:movie_app/features/wishlist/domain/respositories/wishlist_respository.dart';
import '../../data/models/wishlist_item_dto.dart';

class WishlistUseCase {
  final WishlistRepository repository;

  WishlistUseCase(this.repository);

  Future<void> call(WishlistItemDto item) async {
    await repository.toggleWishlist(item);
  }
}