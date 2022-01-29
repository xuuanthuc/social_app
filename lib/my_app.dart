import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/animation/animation_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/auth/auth_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/home/home_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/profile/profile_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/search/search_bloc.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import 'package:hii_xuu_social/src/utilities/route_observer.dart';
import '../src/config/config.dart';
import '../src/validators/translation_key.dart';
import 'arc/presentation/blocs/upload/upload_bloc.dart';

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
          BlocProvider<MainBloc>(create: (context) => MainBloc()),
          BlocProvider<UploadBloc>(create: (context) => UploadBloc()),
          BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
          BlocProvider<AnimationBloc>(create: (context) => AnimationBloc()),
          BlocProvider<SearchBloc>(create: (context) => SearchBloc()),
          BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        ],
        child: MaterialApp(
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
        ),
      ),
    );
  }
}
