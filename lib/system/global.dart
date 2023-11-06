
import 'package:shared_preferences/shared_preferences.dart';

bool _hasInitialized = false;

//Initialize all global things here.
initializeGlobalStuffs() async {
  _prefs = await SharedPreferences.getInstance();

  _hasInitialized = true;
}

bool globalStuffsHasInitialized() {
  return _hasInitialized;
}

//-- Shared Pref --
late SharedPreferences _prefs;
SharedPreferences get prefs {
  return _prefs;
}
