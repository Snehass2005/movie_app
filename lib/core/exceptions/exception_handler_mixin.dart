import 'dart:io';
import 'package:dio/dio.dart';

mixin ExceptionHandlerMixin {
  String getErrorMessage(Object error, {String endpoint = ''}) {
    if (error is DioException) {
      // Handle OMDb error JSON
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('Error')) {
          return data['Error']; // ✅ OMDb error field
        }
        if (data.containsKey('message')) {
          return data['message'];
        }
      }

      if (error.response?.statusCode == 401) {
        return 'Session expired. Please login again.';
      }

      return error.message ?? 'Internal error occurred';
    } else if (error is SocketException) {
      return 'Unable to connect to server';
    } else {
      return 'Unknown error occurred';
    }
  }
}