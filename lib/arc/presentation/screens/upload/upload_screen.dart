import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/custom_button.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import '../../../../arc/presentation/blocs/upload/upload_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UploadBloc>(
      create: (context) => UploadBloc(),
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  void sharePost() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: theme.backgroundColor,
        title: Text('HiXu'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildShareBtn(theme),
            Padding(
              padding: const EdgeInsets.all(Dimens.size10),
              child: Container(
                  decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      TextField(
                        maxLines: 7,
                        style: theme.textTheme.headline6,
                        decoration: InputDecoration(
                          hintText: TranslationKey.descriptionPost.tr(),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(Dimens.size10),
                        child: Row(
                          children: [
                            Container(
                              height: Dimens.size40,
                              width: Dimens.size60,
                              decoration: BoxDecoration(
                                color: theme.primaryColorLight,
                                border: Border.all(width: 1, color: theme.primaryColor),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(Dimens.size10),
                                child: Image.asset(MyImages.icCameraSelected),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildShareBtn(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.size20,
        vertical: Dimens.size10,
      ),
      color: theme.backgroundColor,
      child: Row(
        children: [
          Container(
            width: Dimens.size52,
            height: Dimens.size52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border:
                  Border.all(width: Dimens.size2, color: theme.primaryColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.size2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: StaticVariable.myData?.imageUrl == ''
                    ? Image.asset(
                        MyImages.defaultAvt,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        StaticVariable.myData?.imageUrl ?? '',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          const SizedBox(width: Dimens.size10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StaticVariable.myData?.fullName ?? '',
                style: theme.textTheme.headline5,
              ),
              Text(
                '@' + (StaticVariable.myData?.username ?? ''),
                style: theme.primaryTextTheme.subtitle1,
              ),
            ],
          ),
          const Spacer(),
          CustomButton(
            onTap: sharePost,
            sizeWidth: Dimens.size90,
            sizeHeight: Dimens.size30,
            borderRadius: 10,
            label: TranslationKey.share.tr(),
          )
        ],
      ),
    );
  }
}
