import 'en.dart';

class AppLocalizations {
  static final Map<String, String> _strings = en;

  static String t(String key) {
    return _strings[key] ?? key; // fallback if missing
  }
}