
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _hasInitialized = false;

//Initialize all global things here.
initializeGlobalStuffs() async {
  _packageInfo = await PackageInfo.fromPlatform();
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

//-- Package Info --
late PackageInfo _packageInfo;

String get appName {
  return _packageInfo.appName;
}

String get packageName {
  return _packageInfo.packageName;
}

String get version {
  return 'v${_packageInfo.version} ${(kDebugMode) ? ' - Debug' : ''}${(kProfileMode) ? ' - Profile' : ''}${(kReleaseMode) ? ' - Release' : ''}';
}

String get buildNumber {
  return _packageInfo.buildNumber;
}
