import 'package:shared_preferences/shared_preferences.dart';

class SharedStore {
  static final SharedStore _instance = SharedStore._internal();

  factory SharedStore() => _instance;

  SharedStore._internal();

  late final SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  int getThemeMode() {
    return prefs.getInt('theme-mode') ?? 0;
  }

  Future<void> setThemeMode(int value) async {
    await prefs.setInt('theme-mode', value);
  }
}
