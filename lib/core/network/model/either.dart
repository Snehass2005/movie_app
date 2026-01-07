// A generic Either type to represent success (Right) or failure (Left).

abstract class Either<L, R> {
  const Either();

  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn);

  bool isLeft();
  bool isRight();
}

class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) {
    return leftFn(value);
  }

  @override
  bool isLeft() => true;

  @override
  bool isRight() => false;
}

class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) {
    return rightFn(value);
  }

  @override
  bool isLeft() => false;

  @override
  bool isRight() => true;
}