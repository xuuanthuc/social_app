import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';

class EmptyHome extends StatelessWidget {
  final VoidCallback onFindPeople;

  const EmptyHome({Key? key, required this.onFindPeople}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: Dimens.size40),
            SizedBox(
                width: size.width * 0.4,
                child: Image.asset(MyImages.icEmptyHome)),
            const SizedBox(height: Dimens.size20),
            Text(
              TranslationKey.welcomeHome.tr(),
              textAlign: TextAlign.center,
              style: theme.primaryTextTheme.headline1?.copyWith(
                fontWeight: FontWeight.w100,
                fontFamily: 'RobotoLight',
                fontSize: Dimens.textSize26,
              ),
            ),
            const SizedBox(height: Dimens.size15),
            Text(
              TranslationKey.desWelcomeHome.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.headline4?.copyWith(
                fontWeight: FontWeight.w100,
                fontFamily: 'RobotoLight',
              ),
            ),
            const SizedBox(height: Dimens.size10),
            TextButton(
                onPressed: onFindPeople,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Image.asset(MyImages.icAddUser),
                      width: Dimens.size20,
                    ),
                    const SizedBox(width: Dimens.size10),
                    Text(
                      TranslationKey.findPeople.tr(),
                      textAlign: TextAlign.center,
                      style: theme.primaryTextTheme.headline6,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
