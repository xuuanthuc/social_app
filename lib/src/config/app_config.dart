import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hii_xuu_social/src/styles/colors.dart';

class AppConfig {
  static final AppConfig _appConfig = AppConfig._();
  static AppConfig get instance => _appConfig;

  AppConfig._();

  String get apiEndpoint => 'https://river-eco-hv2wn47voq-as.a.run.app/graphql';
  String get apiGGMapKey => 'AIzaSyCFnQ3D-vZzZlDeQ-ikBIFwWHduVKlgt_s';

  String get cUser => 'users';
  String get cProfile => 'profile';
  String get cUserData => 'user_data';
  String get cBasicProfile => 'basic_profile';
  String get cConnect => 'connect';
  String get cMedia => 'media';
  String get cFollowers => 'followers';
  String get cFollowing => 'following';

  Future<void> configApp() async {
    initDependencies();
    configLoading();
  }

  void initDependencies() async {
    // await AppDependencies.initialize();
  }

  void configLoading() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..maskType = EasyLoadingMaskType.custom
      ..loadingStyle = EasyLoadingStyle.custom
      ..textColor = MyColors.whiteColor
      ..indicatorSize = 40.0
      ..radius = 12.0
      ..backgroundColor = MyColors.secondaryColor.withOpacity(0.2)
      ..indicatorColor = MyColors.primaryColor
      ..maskColor = MyColors.whiteColor.withOpacity(0.1)
      ..userInteractions = false
      ..dismissOnTap = false;
  }
}
