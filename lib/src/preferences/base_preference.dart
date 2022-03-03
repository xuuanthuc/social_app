import 'package:shared_preferences/shared_preferences.dart';


abstract class BasePreference {
  Future getLocal(String key) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key);
  }

  Future getListString(String key) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getStringList(key);
  }

  Future getBool(String key) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(key);
  }

  Future setListString(String key, List<String>? value) async {
    final _prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await _prefs.remove(key);
    } else {
      await _prefs.setStringList(key, value);
    }
  }

  Future setLocal(String key, String? value) async {
    final _prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await _prefs.remove(key);
    } else {
      await _prefs.setString(key, value);
    }
  }

  Future setBool(String key, bool? value) async {
    final _prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await _prefs.remove(key);
    } else {
      await _prefs.setBool(key, value);
    }
  }

  Future clearLocal() async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
  }
}
