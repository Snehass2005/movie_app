import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/dependency_injection/injector.dart';
import 'main/app_env.dart';
import 'main/app.dart';

void main() => mainCommon(AppEnvironment.prod);

Future<void> mainCommon(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize environment-specific configuration
  EnvInfo.initialize(environment);

  // Initialize dependency injection with OMDb API values
  await initDependencies(
    omdbBaseUrl: EnvInfo.baseUrl,
    omdbApiKey: EnvInfo.apiKey,
  );

  // Run the app
  runApp(const MyApp(languageConfig: {},));
}