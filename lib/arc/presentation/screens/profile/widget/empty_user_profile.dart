import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';

import '../../../../../src/styles/dimens.dart';
import '../../../../../src/styles/images.dart';
import '../../../../../src/validators/translation_key.dart';

class EmptyUserProfile extends StatelessWidget {
  final String? fullName;

  const EmptyUserProfile({Key? key, this.fullName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(Dimens.size20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: Dimens.size40,
            child: SvgPicture.asset(
              MyImages.icAnimal,
              color: theme.primaryColor.withOpacity(0.3),
            ),
          ),
          const SizedBox(width: Dimens.size15),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TranslationKey.noPost.tr(),
                  style: theme.primaryTextTheme.headline2?.copyWith(
                    fontWeight: FontWeight.w100,
                    fontFamily: 'RobotoLight',
                  ),
                ),
                const SizedBox(height: Dimens.size5),
                Text(
                  TranslationKey.when.tr() +
                      (fullName ?? Constants.fullNameDefault) +
                      TranslationKey.desNoPost.tr(),
                  style: theme.textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.w100,
                    fontFamily: 'RobotoLight',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
