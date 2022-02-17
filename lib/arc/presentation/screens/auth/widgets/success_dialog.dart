import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/custom_button.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback? onTap;

  const SuccessDialog({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      content: SizedBox(
        width: size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Dimens.size30),
            SizedBox(
                width: size.width * 0.5, child: Image.asset(MyImages.icSmile)),
            const SizedBox(height: Dimens.size20),
            Text(
              TranslationKey.success.tr(),
              style: theme.primaryTextTheme.headline2,
            ),
            const SizedBox(height: Dimens.size20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.size20),
              child: Text(
                TranslationKey.welcome.tr(),
                style: theme.primaryTextTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimens.size20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.size50),
              child: CustomButton(
                onTap: onTap!,
                label: TranslationKey.joinNow.tr(),
              ),
            ),
            const SizedBox(height: Dimens.size30),
          ],
        ),
      ),
    );
  }
}
