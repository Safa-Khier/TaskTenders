import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.setBool('isFirstLaunch', true);
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ??
        true; // Default to true if it doesn't exist

    if (isFirstLaunch) {
      // If it's the first launch, set it to false for subsequent launches
      await prefs.setBool('isFirstLaunch', false);
    }
    // prefs.setBool('isFirstLaunch', true);

    return isFirstLaunch;
  }
}
