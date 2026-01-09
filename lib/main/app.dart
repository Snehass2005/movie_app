import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:movie_app/core/constants/app_language.dart';
import 'package:movie_app/main/app_env.dart';
import 'package:movie_app/routes/app_router.dart';
import 'package:movie_app/shared/theme/app_theme.dart';

class MyApp extends StatelessWidget {

  const MyApp({super.key, required this.languageConfig});


  final Map<String, Map<String, String>> languageConfig;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: EnvInfo.appName, // Dynamic title based on environment
      theme: AppTheme.lightTheme,
      translations: AppTranslations(languageConfig),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
    );
  }
}