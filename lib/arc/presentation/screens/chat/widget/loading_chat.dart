import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/shimmer_widget.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';
class LoadingChatScreen extends StatefulWidget {
  const LoadingChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<LoadingChatScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        color: theme.backgroundColor,
        child: Column(
          children: [
            Container(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.size15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TranslationKey.message.tr(),
                    style: theme.primaryTextTheme.headline1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.size15),
              child: SizedBox(
                height: Dimens.size100,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimens.size20, vertical: Dimens.size12),
                      child: Column(
                        children: const [
                          ShimmerWidget.rectangular(
                            height: Dimens.size50,
                            width: Dimens.size50,
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: 5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.size15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TranslationKey.recentChat.tr(),
                    style: theme.primaryTextTheme.headline2,
                  ),
                  _buildMyAvatar(theme),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: theme.backgroundColor,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.size15, vertical: Dimens.size8),
                      child: Container(
                        width: 500,
                        height: 1,
                        color: theme.shadowColor,
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                    return _chatItem(theme);
                  },
                  itemCount: 5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _chatItem(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.size15,
          vertical: Dimens.size8),
      child: Row(
        children: [
          const ShimmerWidget.rectangular(
            height: Dimens.size50,
            width: Dimens.size50,
          ),
          const SizedBox(width: Dimens.size15),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: const [
              ShimmerWidget.rectangular(
                height: Dimens.size15,
                width: Dimens.size100,
              ),
              SizedBox(height: Dimens.size10),
              ShimmerWidget.rectangular(
                height: Dimens.size15,
                width: Dimens.size150,
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildMyAvatar(ThemeData theme) {
    return SizedBox(
      width: Dimens.size30,
      height: Dimens.size30,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: StaticVariable.myData?.imageUrl == ''
            ? Image.asset(
          MyImages.defaultAvt,
          fit: BoxFit.cover,
        )
            : CachedNetworkImage(
          imageUrl: StaticVariable.myData?.imageUrl ?? '',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
