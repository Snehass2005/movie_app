import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// AppTranslations
///
/// Provides English translations to the app using GetX.
class AppTranslations extends Translations {
  final Map<String, Map<String, String>> languageConfig;

  AppTranslations(this.languageConfig);

  @override
  Map<String, Map<String, String>> get keys => languageConfig;
}

Future<Map<String, Map<String, String>>> loadTranslations() async {
  final Map<String, Map<String, String>> translations = {};

  // English only
  final enJson = await rootBundle.loadString('assets/language/en.json');
  translations['en'] = Map<String, String>.from(json.decode(enJson));

  return translations;
}