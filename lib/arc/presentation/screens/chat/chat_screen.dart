import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/chat/chat_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/chat/widget/loading_chat.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

import '../../../../src/validators/translation_key.dart';
import 'child/box_chat_screen.dart';
import 'package:easy_localization/easy_localization.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<UserData> _listRoomChat = [];
  List<UserData> _listSuggetUser = [];

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadListRoomChatEvent());
  }

  void goToBoxChat(UserData user) {
    navService.push(
      MaterialPageRoute(
        builder: (context) => BoxChatScreen(
          userId: user.userId ?? '',
          username: user.fullName ?? '',
          imageUser: user.imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is LoadListRoomChatSuccessState) {
          _listRoomChat = state.listRoomChat;
          _listSuggetUser = state.listSuggetUser;
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is LoadingRoomChatState) {
            return const LoadingChatScreen();
          }
          return Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: theme.backgroundColor,
              child: Column(
                children: [
                  Container(height: 50),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.size15),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.size15),
                    child: SizedBox(
                      height: Dimens.size100,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return _buildItemSugget(index, theme);
                        },
                        itemCount: _listSuggetUser.length,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.size15),
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
                                horizontal: Dimens.size15,
                                vertical: Dimens.size8),
                            child: Container(
                              width: 500,
                              height: 1,
                              color: theme.shadowColor,
                            ),
                          );
                        },
                        itemBuilder: (context, index) {
                          return _chatItem(theme, index);
                        },
                        itemCount: _listRoomChat.length,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  GestureDetector _buildItemSugget(int index, ThemeData theme) {
    return GestureDetector(
      onTap: () => goToBoxChat(_listSuggetUser[index]),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimens.size10, vertical: Dimens.size12),
        child: Column(
          children: [
            _buildAvatar(theme, _listSuggetUser[index]),
            const SizedBox(height: Dimens.size5),
            SizedBox(
              width: Dimens.size80,
              child: Text(
                _listSuggetUser[index].fullName ?? '',
                style: theme.primaryTextTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _chatItem(ThemeData theme, int index) {
    return GestureDetector(
      onTap: () => goToBoxChat(_listRoomChat[index]),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.size15, vertical: Dimens.size8),
          child: Row(
            children: [
              _buildAvatar(theme, _listRoomChat[index]),
              const SizedBox(width: Dimens.size15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _listRoomChat[index].fullName ?? '',
                    style: theme.textTheme.headline5,
                  ),
                  const SizedBox(height: Dimens.size5),
                  Text(
                    _listRoomChat[index].bio ?? '',
                    style: theme.primaryTextTheme.subtitle1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme, UserData _user) {
    return SizedBox(
      width: Dimens.size50,
      height: Dimens.size50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: _user.imageUrl == ''
            ? Image.asset(
                MyImages.defaultAvt,
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                imageUrl: _user.imageUrl ?? '',
                fit: BoxFit.cover,
              ),
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
