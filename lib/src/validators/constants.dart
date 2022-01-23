import 'package:flutter/material.dart';

class Constants{
  static List<Locale> languages = const [
    Locale('en'),
    Locale('vi'),
  ];
}


class PreferenceKeys {
  static const String xToken = 'X_TOKEN';
  static const String seen = 'SEEN';
  static const String language = 'LANGUAGE';
  static const String colorMode = 'COLORMODE';
  static const String theme = 'THEME';
  static const String username = 'USERNAME';
  static const String password = 'PASSWORD';
  static const String remember = 'REMEMBER';
  static const String verificationId = 'VERIFICATIONID';
}