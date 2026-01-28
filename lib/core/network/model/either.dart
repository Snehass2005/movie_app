/// A generic Either type to represent success (Right) or failure (Left).
abstract class Either<L, R> {
  const Either();

  /// Fold allows you to handle both cases in one go.
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn);

  bool get isLeft;
  bool get isRight;

  L? get leftOrNull;
  R? get rightOrNull;

  /// Transform the Right value if present
  Either<L, T> map<T>(T Function(R r) transform) {
    return fold(
          (l) => Left<L, T>(l),
          (r) => Right<L, T>(transform(r)),
    );
  }

  /// Transform the Left value if present
  Either<T, R> mapLeft<T>(T Function(L l) transform) {
    return fold(
          (l) => Left<T, R>(transform(l)),
          (r) => Right<T, R>(r),
    );
  }

  /// Run side-effect if Left
  void onLeft(void Function(L l) action) {
    if (isLeft && leftOrNull != null) {
      action(leftOrNull as L);
    }
  }

  /// Run side-effect if Right
  void onRight(void Function(R r) action) {
    if (isRight && rightOrNull != null) {
      action(rightOrNull as R);
    }
  }
}

class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) {
    return leftFn(value);
  }

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  L get leftOrNull => value;

  @override
  R? get rightOrNull => null;
}

class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) {
    return rightFn(value);
  }

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  L? get leftOrNull => null;

  @override
  R get rightOrNull => value;
}