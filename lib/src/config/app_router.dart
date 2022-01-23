import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/presentation/screens/auth/login_screen.dart';
import '../../arc/presentation/screens/main/main_screen.dart';
import '../../arc/presentation/screens/splash/splash_screen.dart';

import 'config.dart';

class AppRoutes {
  static Route? onGenerateRoutes(RouteSettings settings) {
    String routeSettings = settings.name ?? '';
    switch (settings.name) {
      case RouteKey.splash:
        return _materialRoute(routeSettings, const SplashScreen());
      case RouteKey.main:
        return _materialRoute(routeSettings,const MainScreen());
      case RouteKey.login:
        return _materialRoute(routeSettings,const LoginScreen());
      default:
        return null;
    }
  }

  static List<Route> onGenerateInitialRoute() {
    return [_materialRoute(RouteKey.splash, const SplashScreen())];
  }

  static Route<dynamic> _materialRoute(String routeSettings, Widget view) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeSettings), builder: (_) => view);
  }
}
