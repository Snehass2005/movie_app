import 'package:bloc/bloc.dart';
import 'package:movie_app/core/exceptions/http_exception.dart';
import 'package:movie_app/core/network/model/either.dart';
import 'package:movie_app/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:movie_app/features/wishlist/domain/usecases/wishlist_usecases.dart';
import 'wishlist_state.dart';

/// WishlistCubit - Handles all wishlist logic using the BLoC pattern.
///
/// Responsibilities:
/// 1. Load wishlist items from local storage
/// 2. Toggle wishlist items (add/remove)
/// 3. Emit states for loading, success, and failure
class WishlistCubit extends Cubit<WishlistState> {
  final WishlistUseCases _wishlistUseCases;

  WishlistCubit(this._wishlistUseCases) : super(const WishlistState());

  /// Loads all wishlist items
  Future<void> loadWishlist() async {
    emit(state.copyWith(isLoading: true));

    Either<AppException, List<WishlistItemModel>> result =
    await _wishlistUseCases.getWishlist();

    result.fold(
          (error) {
        // Inline logging instead of ErrorLogger
        print('WishlistCubit.loadWishlist error: ${error.identifier}');
        emit(state.copyWith(
          message: error.message,
          isLoading: false,
          isFailure: true,
          isSuccess: false,
        ));
      },
          (items) {
        emit(state.copyWith(
          items: items,
          isLoading: false,
          isSuccess: true,
          isFailure: false,
        ));
      },
    );
  }

  /// Toggles a wishlist item (add/remove)
  Future<void> toggleWishlist(WishlistItemModel item) async {
    emit(state.copyWith(isLoading: true));

    Either<AppException, bool> result =
    await _wishlistUseCases.toggleWishlist(item: item);

    result.fold(
          (error) {
        print('WishlistCubit.toggleWishlist error: ${error.identifier}');
        emit(state.copyWith(
          message: error.message,
          isLoading: false,
          isFailure: true,
          isSuccess: false,
        ));
      },
          (_) async {
        // Reload wishlist after toggle
        await loadWishlist();
      },
    );
  }

  /// Clears state back to default
  void clearState() {
    emit(const WishlistState());
  }

  /// Resets just the error state
  void resetError() {
    emit(state.copyWith(isFailure: false, message: ''));
  }
}