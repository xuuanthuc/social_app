import 'package:flutter/material.dart';

class Constants{
  static List<Locale> languages = const [
    Locale('en'),
    Locale('vi'),
  ];
  static const PageIndex page = PageIndex();
  static const String fullNameDefault = 'Cutepet User';
}

class PageIndex{
  const PageIndex();
  int get home => 0;
  int get chat => 1;
  int get camera => 2;
  int get search => 3;
  int get profile => 4;
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
  static const String seenOnBroad = 'ONBROADINGSCREENSEEN';
  static const String firebaseToken = 'FIREBASE_TOKEN';
}