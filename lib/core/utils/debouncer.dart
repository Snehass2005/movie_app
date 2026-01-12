import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility class to debounce rapid calls into a single action.
/// Useful for search fields, auto-save, etc.
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 500});

  /// Runs the given [action] after [milliseconds] have passed
  /// since the last call. Cancels any previous pending action.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels any pending action.
  void cancel() {
    _timer?.cancel();
  }
}