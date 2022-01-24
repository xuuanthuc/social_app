import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/src/config/config.dart';
import 'package:hii_xuu_social/src/preferences/app_preference.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import 'package:hii_xuu_social/src/utilities/showtoast.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      create: (context) => MainBloc(),
      child: BlocListener<MainBloc, MainState>(
        listener: (context, state) {},
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    print(StaticVariable.listUserId);
    context.read<MainBloc>().add(InitMainEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Container(
          child: Center(
            child: GestureDetector(
                onTap: (){
                  AppPreference().setVerificationID(null);
                  StaticVariable.myData = null;
                  navService.pushReplacementNamed(RouteKey.login);
                },
                child: Text('hhh')),
          ),
        ),
      ),
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          ToastView.withBottom(TranslationKey.tapExit.tr());
          return Future.value(false);
        }
        exit(0);
      },
    );
  }
}
