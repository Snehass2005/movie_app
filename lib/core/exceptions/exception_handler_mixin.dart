import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// A mixin to handle API and network exceptions gracefully.
mixin ExceptionHandlerMixin<T extends StatefulWidget> on State<T> {
  void handleException(Object error, {String endpoint = ''}) {
    String message;

    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        message = 'Session expired. Please login again.';
      } else {
        message = error.response?.data?['message'] ?? 'Internal error occurred';
      }
    } else if (error is SocketException) {
      message = 'Unable to connect to server';
    } else {
      message = 'Unknown error occurred';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}