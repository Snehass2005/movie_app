import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/wishlist/domain/respositories/wishlist_respository.dart';
import 'package:movie_app/features/wishlist/domain/usecases/wishlist_usecases.dart';
import '../../data/models/wishlist_item_dto.dart';

import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistUseCase toggleWishlistUseCase;
  final WishlistRepository repository;

  WishlistCubit(this.toggleWishlistUseCase, this.repository)
      : super(WishlistState(items: []));

  Future<void> loadWishlist() async {
    emit(state.copyWith(isLoading: true));
    final items = await repository.getWishlist();
    emit(WishlistState(items: items, isLoading: false));
  }

  Future<void> toggleWishlist(WishlistItemDto item) async {
    await toggleWishlistUseCase(item);
    await loadWishlist();
  }
}