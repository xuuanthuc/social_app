import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/app_bloc.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/service/event_bus.dart';
import '../src/validators/constants.dart';

import 'arc/di/service_locator.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.instance.configApp();
  eventBus.on().listen((event) {
    debugPrint('eventBus - event => ${event.runtimeType}');
  });
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDs-ii2Rfdg0fJOxm3bJ-mVYTCbem0hBns',
      appId: '1:641930232253:android:d9232901d384da2853d2d4',
      messagingSenderId: '641930232253',
      projectId: 'hiixuu-aa7cd',
    ),
  );
  setupLocator();
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: Constants.languages,
      startLocale: Constants.languages[0],
      fallbackLocale: Constants.languages[0],
      child: BlocOverrides.runZoned(
        () => const MyApp(),
        blocObserver: AppBlocObserver(),
      ),
    ),
  );
}
