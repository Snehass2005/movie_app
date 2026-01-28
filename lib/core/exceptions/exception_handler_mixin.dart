import 'dart:io';
import 'package:dio/dio.dart';

/// A mixin to normalize API and network exceptions.
/// Use this in Cubits, Repositories, or DataSources to convert errors into user-friendly messages.
mixin ExceptionHandlerMixin {
  String getErrorMessage(Object error, {String endpoint = ''}) {
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        return 'Session expired. Please login again.';
      }
      return error.response?.data?['message'] ?? 'Internal error occurred';
    } else if (error is SocketException) {
      return 'Unable to connect to server';
    } else {
      return 'Unknown error occurred';
    }
  }
}