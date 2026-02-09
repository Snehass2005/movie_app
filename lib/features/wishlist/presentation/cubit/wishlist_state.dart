import 'package:equatable/equatable.dart';
import 'package:movie_app/features/wishlist/data/models/wishlist_item_model.dart';

/// WishlistState - Holds all the data for the wishlist feature.
///
/// What is State?
/// - State is like a snapshot of the current situation
/// - It holds all the data the UI needs to display
/// - When state changes, the UI rebuilds to show the new data
///
/// Why use a single state class?
/// - Makes it easy to track what's happening
/// - All related data stays together
/// - Using copyWith() makes updating safe and clean
///
/// Properties:
/// - message: Error or success message
/// - items: List of wishlist items
/// - isLoading: True when operation is in progress
/// - isFailure: True when operation failed
/// - isSuccess: True when operation succeeded
class WishlistState extends Equatable {
  final String message;
  final List<WishlistItemModel> items;
  final bool isLoading;
  final bool isFailure;
  final bool isSuccess;

  /// Constructor with default values
  const WishlistState({
    this.message = '',
    this.items = const [],
    this.isLoading = false,
    this.isFailure = false,
    this.isSuccess = false,
  });

  /// Creates a new state with some values changed.
  WishlistState copyWith({
    String? message,
    List<WishlistItemModel>? items,
    bool? isLoading,
    bool? isFailure,
    bool? isSuccess,
  }) {
    return WishlistState(
      message: message ?? this.message,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  /// Tells Equatable which fields to compare.
  @override
  List<Object?> get props => [
    message,
    items,
    isLoading,
    isFailure,
    isSuccess,
  ];
}