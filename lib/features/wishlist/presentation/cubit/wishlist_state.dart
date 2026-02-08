import '../../data/models/wishlist_item_dto.dart';

class WishlistState {
  final List<WishlistItemDto> items;
  final bool isLoading;

  WishlistState({required this.items, this.isLoading = false});

  WishlistState copyWith({List<WishlistItemDto>? items, bool? isLoading}) {
    return WishlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}