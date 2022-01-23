import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../src/validators/constants.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: Constants.languages,
      startLocale: Constants.languages[0],
      fallbackLocale: Constants.languages[0],
      child: const MyApp(),
    ),
  );
}
