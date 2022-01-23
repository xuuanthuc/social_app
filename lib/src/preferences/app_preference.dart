import 'package:hii_xuu_social/src/validators/constants.dart';

import 'base_preference.dart';

class AppPreference extends BasePreference {

  Future setVerificationID(String? value) async =>
      await setLocal(PreferenceKeys.verificationId, value);

  Future<String?> get verificationId async => await getLocal(PreferenceKeys.verificationId);
  //
  // Future<String?> get token async => await getLocal(PreferenceKeys.xToken);
  //
  // Future setToken(String? value) async =>
  //     await setLocal(PreferenceKeys.xToken, value);
  //
  // Future<String?> get seen async => await getLocal(PreferenceKeys.seen);
  //
  // Future setSeen(String value) async =>
  //     await setLocal(PreferenceKeys.seen, value);
  //
  // Future<String?> get language async => await getLocal(PreferenceKeys.language);

  // Future setLanguage(String value) async =>
  //     await setLocal(PreferenceKeys.language, value);
  // Future<String?> get verificationID async =>
  //     await getLocal(PreferenceKeys.verificationId);
  //

  // Future<String?> get colorMode async =>
  //     await getLocal(PreferenceKeys.colorMode);
  //
  // Future setColorMode(String value) async =>
  //     await setLocal(PreferenceKeys.colorMode, value);
  //
  // Future<String?> get remember async => await getLocal(PreferenceKeys.remember);
  //
  // Future setRememberUser(String? value) async =>
  //     await setLocal(PreferenceKeys.remember, value ?? '');
  //
  // Future<String?> get username async => await getLocal(PreferenceKeys.username);
  //
  // Future setUsername(String? value) async =>
  //     await setLocal(PreferenceKeys.username, value ?? '');
  //
  // Future<String?> get password async => await getLocal(PreferenceKeys.password);
  //
  // Future setPassword(String? value) async =>
  //     await setLocal(PreferenceKeys.password, value ?? '');
  //
  // Future<String?> get theme async => await getLocal(PreferenceKeys.theme);
  //
  // Future setTheme(String value) async =>
  //     await setLocal(PreferenceKeys.seen, value);
  //
  // Future setSavedIds(List<String>? value) async =>
  //     await setListString(PreferenceKeys.savedIds, value);
  //
  // Future<List<String>?> get savedIds async =>
  //     await getListString(PreferenceKeys.savedIds);
  //
  // Future<String?> get mapType async => await getLocal(PreferenceKeys.mapType);
  //
  // Future setMapType(String value) async =>
  //     await setLocal(PreferenceKeys.mapType, value);
  //
  // Future setLocation(List<String>? value) async =>
  //     await setListString(PreferenceKeys.location, value);
  //
  // Future<List<String>?> get location async =>
  //     await getListString(PreferenceKeys.location);
}
