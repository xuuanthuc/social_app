import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/app_bloc.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import '../src/validators/constants.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.instance.configApp();
  await Firebase.initializeApp();
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: Constants.languages,
      startLocale: Constants.languages[0],
      fallbackLocale: Constants.languages[0],
      child: BlocOverrides.runZoned( ()=> const MyApp(),
        blocObserver: AppBlocObserver(),
      ),
    ),
  );
}
