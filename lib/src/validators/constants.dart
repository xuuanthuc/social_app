import 'package:flutter/material.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';

import '../../arc/data/models/data_models/shop.dart';
import 'package:easy_localization/easy_localization.dart';

class Constants {
  static List<Locale> languages = const [
    Locale('en'),
    Locale('vi'),
  ];
  static const PageIndex page = PageIndex();
  static const CategoryStore categoryStore = CategoryStore();
  static const String fullNameDefault = 'Cutepet User';
}

class PageIndex {
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

class CategoryStore {
  const CategoryStore();

  List<CategoryShop> get listCategory => [
    CategoryShop(),
    CategoryShop(value: 0, label: TranslationKey.category1.tr()),
    CategoryShop(value: 1, label: TranslationKey.category2.tr()),
    CategoryShop(value: 2, label: TranslationKey.category3.tr()),
    CategoryShop(value: 2, label: TranslationKey.category4.tr()),
    CategoryShop(value: 3, label: TranslationKey.category5.tr()),
  ];
}
