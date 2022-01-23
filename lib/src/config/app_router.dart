import 'package:flutter/material.dart';
import '../../arc/presentation/screens/main/main_screen.dart';
import '../../arc/presentation/screens/splash/splash_screen.dart';

import 'config.dart';

class AppRoutes {
  static Route? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteKey.splash:
        return _materialRoute(const SplashScreen());
      case RouteKey.main:
        final args = settings.arguments as int;
        return _materialRoute(MainScreen());
      default:
        return null;
    }
  }

  static List<Route> onGenerateInitialRoute() {
    return [_materialRoute(const SplashScreen())];
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute<String>(builder: (_) => view);
  }
}
