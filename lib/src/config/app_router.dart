import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/presentation/screens/auth/login_screen.dart';
import 'package:hii_xuu_social/arc/presentation/screens/auth/setup_profile_screen.dart';
import 'package:hii_xuu_social/arc/presentation/screens/home/child/full_image.dart';
import 'package:hii_xuu_social/arc/presentation/screens/upload/child/file_image.dart';
import '../../arc/presentation/screens/main/main_screen.dart';
import '../../arc/presentation/screens/splash/splash_screen.dart';
import 'dart:io';
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
      case RouteKey.setUpProfile:
        return _materialRoute(routeSettings,const SetUpProfileScreen());
      // case RouteKey.fullImage:
      //   var image = settings.arguments as String;
      //   return _materialRoute(routeSettings, FullImageScreen(image: image));
      case RouteKey.fullImageFile:
        var image = settings.arguments as File;
        return _materialRoute(routeSettings, FullImageFileScreen(image: image));
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
