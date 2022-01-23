import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hii_xuu_social/arc/presentation/screens/splash/splash_screen.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import 'package:hii_xuu_social/src/utilities/route_observer.dart';
import '../src/config/config.dart';
import '../src/validators/translation_key.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TranslationKey.appName.tr(),
      builder: EasyLoading.init(),
      navigatorObservers: [MyRouteObserver()],
      navigatorKey: NavigationService.navigationKey,
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      onGenerateInitialRoutes: (_) => AppRoutes.onGenerateInitialRoute(),
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      theme: MyTheme.lightTheme(),
      darkTheme: MyTheme.darkTheme(),
      themeMode: ThemeMode.system,
    );
  }
}
