import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/data/models/request_models/post_comment.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/home/home_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/home/widget/loading_comment.dart';
import 'package:hii_xuu_social/arc/presentation/screens/profile/user_profile.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/format.dart';
import 'package:hii_xuu_social/src/utilities/showtoast.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

import '../../../blocs/notice/notice_bloc.dart';
import 'comment_setting_dialog.dart';

class CommentSheet extends StatefulWidget {
  final PostData postItem;

  const CommentSheet({Key? key, required this.postItem}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<CommentSheet> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _commentController = TextEditingController();
  bool _canComment = false;
  List<CommentModel>? _listComment = [];
  bool _autoFocus = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    context.read<HomeBloc>().add(LoadListComment(widget.postItem));
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
  }

  void _onCommentPost(ScrollController _scrollController) async {
    await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease);
    context.read<HomeBloc>().add(OnCommentEvent(
        comment: _commentController.text, post: widget.postItem));
    StaticVariable.comment = CommentModel(
        content: _commentController.text,
        authName: StaticVariable.myData?.fullName,
        authAvatar: StaticVariable.myData?.imageUrl,
        updateAt: 'Posting...');
  }

  Future<void> _showCommentSetting(CommentModel comment) async {
    await showDialog<void>(
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: CommentSettingSheet(
                postItem: widget.postItem,
                commentModel: comment,
              )),
        );
      },
    );
  }

  void showUserProfile(String userId) {
    _focus.unfocus();
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

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is OnCommentTextChangedState) {
          if (_commentController.text.trim().isNotEmpty) {
            _canComment = true;
          } else {
            _canComment = false;
          }
        }
        if (state is OnCommentSuccessState) {
          _commentController.clear();
          _canComment = false;
          _focus.unfocus();
          if(widget.postItem.userId != StaticVariable.myData?.userId) {
            context.read<NoticeBloc>().add(CommentPostNoticeEvent(
                authId: widget.postItem.userId ?? '',
                userCommentedId: StaticVariable.myData?.userId ?? ''));
          }
          context.read<HomeBloc>().add(ReloadListComment(widget.postItem));
        }
        if (state is LoadListCommentSuccessState) {
          _listComment = state.listComment;
          _autoFocus = true;
        }
        if (state is LoadListCommentFailedState) {
          ToastView.show('Something wrong!');
        }
        if (state is OnCommentFailedState) {
          ToastView.show('Something wrong!');
        }
        if (state is ReloadingListCommentState) {
          _listComment?.add(StaticVariable.comment!);
        }
        if (state is DeleteCommentSuccessState) {
          _listComment?.removeWhere((element) => element.id == state.commentId);
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is LoadingListCommentState) {
            return const LoadingComment();
          }
          return DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 0.7,
            maxChildSize: 1,
            snap: true,
            expand: false,
            builder: (context, _scrollController) => Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Container(
                    height: 50,
                    color: Colors.transparent,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(Dimens.size20),
                          topLeft: Radius.circular(Dimens.size20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: Dimens.size20, bottom: Dimens.size10),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final comment = _listComment?[index];
                            return _buildComment(comment);
                          },
                          itemCount: _listComment?.length ?? 0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: theme.backgroundColor,
                    height: Dimens.size55,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.size10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: Dimens.size15),
                          _buildAvatarWidget(theme),
                          const SizedBox(width: Dimens.size10),
                          _buildTextFieldComment(theme),
                          _buildCommentButton(_scrollController),
                          Visibility(
                            visible: !_focus.hasFocus,
                            child: const SizedBox(width: Dimens.size15),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildComment(CommentModel? comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.size15, vertical: Dimens.size15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => showUserProfile(comment?.userId ?? ''),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: SizedBox(
                    height: Dimens.size40,
                    width: Dimens.size40,
                    child: comment?.authAvatar == ''
                        ? Image.asset(
                            MyImages.defaultAvt,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            comment?.authAvatar ?? '',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: Dimens.size10),
              Expanded(
                child: GestureDetector(
                  onLongPress: comment?.userId == StaticVariable.myData?.userId
                      ? () => _showCommentSetting(comment!)
                      : () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.size15, vertical: Dimens.size10),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            color: Theme.of(context).scaffoldBackgroundColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  showUserProfile(comment?.userId ?? ''),
                              child: Text(
                                comment?.authName ?? '',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1,
                              ),
                            ),
                            Text(
                              comment?.content ?? '',
                              style:
                                  Theme.of(context).primaryTextTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: Dimens.size7),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.size55),
            child: Text(TimeAgo.timeAgoSinceDate(comment?.updateAt ?? ''),
                style: Theme.of(context).primaryTextTheme.subtitle1),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWidget(ThemeData theme) {
    return GestureDetector(
      onTap: () => showUserProfile(StaticVariable.myData?.userId ?? ''),
      child: Container(
        height: Dimens.size40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(width: 1, color: theme.primaryColor)),
        width: Dimens.size40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
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
    );
  }

  Visibility _buildCommentButton(ScrollController _scrollController) {
    return Visibility(
      visible: _focus.hasFocus,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: _canComment == true
            ? () => _onCommentPost(_scrollController)
            : () {},
        child: Padding(
          padding: const EdgeInsets.all(Dimens.size15),
          child: SizedBox(
              width: Dimens.size20,
              height: Dimens.size20,
              child: Image.asset(_canComment == true
                  ? MyImages.icSend
                  : MyImages.icSendOutline)),
        ),
      ),
    );
  }

  Expanded _buildTextFieldComment(ThemeData theme) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: TextField(
          focusNode: _focus,
          autofocus: _autoFocus,
          style: theme.textTheme.headline6,
          controller: _commentController,
          cursorHeight: Dimens.size18,
          onChanged: (value) {
            context.read<HomeBloc>().add(OnCommentTextChangedEvent(value));
          },
          decoration: InputDecoration(
              hintText: 'Write comment',
              hintStyle: theme.primaryTextTheme.subtitle1,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: Dimens.size20, vertical: Dimens.size4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.shadowColor.withOpacity(0.7)),
        ),
      ),
    );
  }
}
