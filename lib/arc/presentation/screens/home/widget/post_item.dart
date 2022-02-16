import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/home/home_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/home/child/comment_sheet.dart';
import 'package:hii_xuu_social/arc/presentation/screens/home/child/full_image.dart';
import 'package:hii_xuu_social/arc/presentation/screens/home/child/menu_dialog.dart';
import 'package:hii_xuu_social/arc/presentation/screens/profile/user_profile.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/format.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';

class PostItem extends StatefulWidget {
  PostData item;

  PostItem({Key? key, required this.item}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isSeeMore = false;
  String _currentComment = '0';
  bool _showFavouriteReact = false;

  void showCommentSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      barrierColor: Colors.black45,

      backgroundColor: Colors.transparent,
      builder: (context) {
        return CommentSheet(postItem: widget.item);
      },
    );
    setState(() {
      _currentComment = StaticVariable.listComment?.length.toString() ?? '0';
    });
  }

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


  Future<void> _showSettingDialog(PostData item) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.size60),
          child: AlertDialog(
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Theme.of(context).backgroundColor,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: MenuDialog(item: item),
          ),
        );
      },
    );
  }

  void goToFullImage() {
    navService.push(
      MaterialPageRoute(
        builder: (context) => FullImageScreen(
            image: widget.item.images ?? [],
            countCmt: _currentComment,
            countLike: widget.item.likes?.length.toString() ?? '',
            comment: showCommentSheet,
            post: widget.item),
      ),
    );
  }

  void unLike() {
    context.read<HomeBloc>().add(OnDisLikePostEvent(widget.item));
  }

  void like() async {
    context.read<HomeBloc>().add(OnLikePostEvent(widget.item));
    setState(() {
      _showFavouriteReact = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _showFavouriteReact = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentComment = widget.item.comments?.length.toString() ?? '0';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) async {
        if (state is OnDisLikedPostState) {
          widget.item = state.post;
        }
        if (state is OnLikedPostState) {
          widget.item = state.post;
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.size10, vertical: Dimens.size7),
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
                  (widget.item.images ?? []).isNotEmpty
                      ? _buildListImage(context)
                      : _buildEmptyWidget(),
                  (widget.item.images ?? []).length > 1
                      ? _buildSmallSlideImage(context, theme)
                      : _buildEmptyWidget(),
                  widget.item.content == ''
                      ? _buildEmptyWidget()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: Dimens.size10),
                          child: (widget.item.content ?? '').length > 150
                              ? _buildLongContent(context, theme)
                              : _buildShortContent(theme),
                        ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildFavoriteButton(),
                      Text(
                        widget.item.likes?.length.toString() ?? '0',
                        style: theme.primaryTextTheme.headline4,
                      ),
                      const SizedBox(width: Dimens.size20),
                      _buildCommentButton(),
                      const SizedBox(width: Dimens.size5),
                      Text(
                        _currentComment,
                        style: theme.primaryTextTheme.headline4,
                      ),
                      const Spacer(),
                      // Padding(
                      //   padding: const EdgeInsets.all(Dimens.size10),
                      //   child: SvgPicture.asset(MyImages.icUnSaved),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentButton() {
    return GestureDetector(
      onTap: showCommentSheet,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.size5),
        child: SvgPicture.asset(MyImages.icComment),
      ),
    );
  }

  GestureDetector _buildFavoriteButton() {
    return GestureDetector(
      onTap: widget.item.likes!.contains(StaticVariable.myData?.userId)
          ? unLike
          : like,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.size10),
          child: SvgPicture.asset(
              widget.item.likes!.contains(StaticVariable.myData?.userId)
                  ? MyImages.icLiked
                  : MyImages.icUnLiked),
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
        style: theme.primaryTextTheme.bodyText2,
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
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Dimens.size5),
          child: widget.item.images?.length == 1
              ? Padding(
                  padding: const EdgeInsets.all(Dimens.size5),
                  child: GestureDetector(
                    onDoubleTap: widget.item.likes!
                            .contains(StaticVariable.myData?.userId)
                        ? unLike
                        : like,
                    onTap: goToFullImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.item.images?.first ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.width - Dimens.size30,
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
                            onDoubleTap: widget.item.likes!
                                    .contains(StaticVariable.myData?.userId)
                                ? unLike
                                : like,
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
        ),
        Visibility(
          visible: _showFavouriteReact,
          child: Positioned(
            right: MediaQuery.of(context).size.width * 0.5 - 65,
            bottom: 50,
            child: SizedBox(
              height: Dimens.size100,
              width: Dimens.size100,
              child: SvgPicture.asset(MyImages.icLiked),
            ),
          ),
        )
      ],
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
          const Spacer(),
          InkWell(
            onTap: () => _showSettingDialog(widget.item),
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(MyImages.icMenu),
              ),
            ),
          )
        ],
      ),
    );
  }
}
