import 'package:nuntium/core/constants/constanst.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPrefs {
  AppSharedPrefs(this._preferences);

  final SharedPreferences _preferences;

  /// Checks if its the first time to open the app
  bool get isFirstTime =>
      _preferences.getBool(SharedPrefsKeys.isFirstTime) ?? true;

  Future<void> setIsFirstTimeToFalse() async {
    await _preferences.setBool(SharedPrefsKeys.isFirstTime, false);
  }
}
