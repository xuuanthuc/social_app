import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../src/styles/dimens.dart';
import '../../../../../src/styles/images.dart';
import '../../../../../src/validators/translation_key.dart';

class EmptyMyProfile extends StatelessWidget {
  final int index;

  const EmptyMyProfile({Key? key, required this.index}) : super(key: key);

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
            SizedBox(
                width: size.width * 0.4,
                child: SvgPicture.asset(
                  MyImages.icAnimal,
                  color: theme.primaryColor.withOpacity(0.3),
                )),
            const SizedBox(height: Dimens.size20),
            Text(
              index == 0
                  ? TranslationKey.photos.tr()
                  : TranslationKey.save.tr(),
              textAlign: TextAlign.center,
              style: theme.primaryTextTheme.headline1?.copyWith(
                fontWeight: FontWeight.w100,
                fontFamily: 'RobotoLight',
                fontSize: Dimens.textSize26,
              ),
            ),
            const SizedBox(height: Dimens.size15),
            Text(
              index == 0
                  ? TranslationKey.desNoPhoto.tr()
                  : TranslationKey.desNoSave.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.headline4?.copyWith(
                fontWeight: FontWeight.w100,
                fontFamily: 'RobotoLight',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
