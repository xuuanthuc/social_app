import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/profile/user_profile.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/format.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';

import 'full_image.dart';

class PostItem extends StatefulWidget {
  final PostData item;

  const PostItem({Key? key, required this.item}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isSeeMore = false;

  void showUserProfile(String userId) {
    if (userId == StaticVariable.myData?.userId) {
      context.read<MainBloc>().add(OnChangePageEvent(Constants.page.profile));
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return UserProfile(userId: userId);
          },
        ),
      );
    }
  }

  void goToFullImage() {
    navService.push(
      MaterialPageRoute(
        builder: (context) => FullImageScreen(
            image: widget.item.images ?? []),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.size7),
          child: Container(
            padding: const EdgeInsets.all(Dimens.size5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: theme.backgroundColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoUser(theme),
                const SizedBox(height: Dimens.size10),
                widget.item.content == ''
                    ? _buildEmptyWidget()
                    : Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.size10),
                  child: widget.item.content!.length > 150
                      ? _buildLongContent(context, theme)
                      : _buildShortContent(theme),
                ),
                (widget.item.images?? []).isNotEmpty
                    ? _buildListImage(context)
                    : _buildEmptyWidget(),
                widget.item.images!.length > 1
                    ? _buildSmallSlideImage(context, theme)
                    : _buildEmptyWidget(),
              ],
            ),
          ),
        );
  }

  Container _buildEmptyWidget() => Container();

  Widget _buildShortContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.size10),
      child: Text(
        widget.item.content ?? '',
        style: theme.textTheme.bodyText2,
      ),
    );
  }

  GestureDetector _buildLongContent(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSeeMore = !_isSeeMore;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.size10),
        child: Column(
          children: [
            SizedBox(
              height: _isSeeMore == true ? null : Dimens.size35,
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.item.content ?? '',
                style: theme.primaryTextTheme.bodyText2,
                textAlign: TextAlign.start,
              ),
            ),
            _isSeeMore == false
                ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                TranslationKey.seeMore.tr(),
                style: theme.primaryTextTheme.subtitle1,
                textAlign: TextAlign.end,
              ),
            )
                : _buildEmptyWidget(),
          ],
        ),
      ),
    );
  }

  Container _buildSmallSlideImage(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.size10),
      height: Dimens.size5,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: Dimens.size5,
              height: Dimens.size5,
              margin: const EdgeInsets.symmetric(horizontal: Dimens.size3),
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? theme.primaryColor
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
          itemCount: widget.item.images?.length ?? 0,
        ),
      ),
    );
  }

  Widget _buildListImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.size5),
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.6,
        child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(Dimens.size5),
                child: GestureDetector(
                  onTap: goToFullImage,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.item.images?[index] ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            itemCount: widget.item.images?.length ?? 0),
      ),
    );
  }

  Widget _buildInfoUser(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.size5),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => showUserProfile(widget.item.userId ?? ''),
            child: SizedBox(
              width: Dimens.size40,
              height: Dimens.size40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: widget.item.authAvatar == ''
                    ? Image.asset(
                  MyImages.defaultAvt,
                  fit: BoxFit.cover,
                )
                    : CachedNetworkImage(
                  imageUrl: widget.item.authAvatar ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: Dimens.size10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => showUserProfile(widget.item.userId ?? ''),
                child: Text(
                  widget.item.authName ?? '',
                  style: theme.textTheme.headline5,
                ),
              ),
              Text(
                TimeAgo.timeAgoSinceDate(widget.item.updateAt ?? ''),
                style: theme.primaryTextTheme.subtitle1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}