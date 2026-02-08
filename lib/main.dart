import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/features/wishlist/data/models/wishlist_item_dto.dart';
import 'core/constants/app_language.dart';
import 'core/dependency_injection/injector.dart';
import 'main/app.dart';
import 'main/app_env.dart';

/// Production entry point.
void main() => mainCommon(AppEnvironment.prod);

/// Common initialization function shared across all environments.
Future<void> mainCommon(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize environment-specific configuration
  EnvInfo.initialize(environment);

  await initDependencies();

  // ✅ Hive setup
  await Hive.initFlutter();
  Hive.registerAdapter(WishlistItemDtoAdapter());

  // ⚠️ Clear old box data once if corrupted
  await Hive.deleteBoxFromDisk('wishlist');

  // ✅ Open typed box
  await Hive.openBox<WishlistItemDto>('wishlist');

  // Load translations for the app
  final Map<String, Map<String, String>> translations = await loadTranslations();

  // Run the app
  runApp(MyApp(languageConfig: translations));
}