import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hii_xuu_social/arc/presentation/screens/auth/widgets/auth_bottom_sheet.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/custom_button.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/showtoast.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xffFCF1EE).withOpacity(0.5),
                const Color(0xffFDF5EE).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
            )
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.size30),
            child: ListView(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 300),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: Dimens.size50,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  const SizedBox(height: Dimens.size20),
                  Text(
                    TranslationKey.authTitle.tr(),
                    style: theme.primaryTextTheme.headline1,
                  ),
                  const SizedBox(height: Dimens.size10),
                  Text(
                    TranslationKey.authDescription.tr(),
                    style: theme.primaryTextTheme.headline4,
                  ),
                  const SizedBox(height: Dimens.size20),
                  Padding(
                    padding: const EdgeInsets.all(Dimens.size15),
                    child: Image.asset(MyImages.authImg),
                  ),
                  const SizedBox(height: Dimens.size50),
                  CustomButton.withBorder(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          elevation: 0,
                          isScrollControlled: true,
                          barrierColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimens.size20),
                              topLeft: Radius.circular(Dimens.size20),
                            ),
                          ),
                          backgroundColor: theme.backgroundColor,
                          builder: (context) {
                            return const LoginSheet(initPage: 0);
                          });
                    },
                    label: TranslationKey.login.tr(),
                  ),
                  const SizedBox(height: Dimens.size25),
                  CustomButton(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          elevation: 0,
                          barrierColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimens.size20),
                              topLeft: Radius.circular(Dimens.size20),
                            ),
                          ),
                          backgroundColor: theme.backgroundColor,
                          builder: (context) {
                            return const LoginSheet(initPage: 1);
                          });
                    },
                    label: TranslationKey.register.tr(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          ToastView.withBottom(TranslationKey.tapExit.tr());
          return Future.value(false);
        }
        exit(0);
      },
    );
  }
}
