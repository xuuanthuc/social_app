import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/chat.dart';
import 'package:hii_xuu_social/arc/presentation/screens/profile/user_profile.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/format.dart';

class ItemMyChat extends StatefulWidget {
  final ChatData chat;

  const ItemMyChat({Key? key, required this.chat}) : super(key: key);

  @override
  _ItemMyChatState createState() => _ItemMyChatState();
}

class _ItemMyChatState extends State<ItemMyChat> {
  bool _showTime = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            height: _showTime ? 30 : 0,
            child: Padding(
              padding: const EdgeInsets.only(top: Dimens.size12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TimeAgo.getDate(widget.chat.createAt ?? ''),
                    style: theme.primaryTextTheme.subtitle2,
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showTime = !_showTime;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: Dimens.size80, top: Dimens.size12, right: Dimens.size12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.size15, vertical: Dimens.size10),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: widget.chat.message ?? '',
                            style: theme.primaryTextTheme.bodyText2,
                          ),
                          TextSpan(
                              text:
                                  '   ' + TimeAgo.getTime(widget.chat.createAt ?? ''),
                              style: theme.textTheme.caption)
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ItemOtherChat extends StatefulWidget {
  final ChatData chat;
  final String imageUser;

  const ItemOtherChat({Key? key, required this.chat, required this.imageUser})
      : super(key: key);

  @override
  _ItemOtherChatState createState() => _ItemOtherChatState();
}

class _ItemOtherChatState extends State<ItemOtherChat> {
  bool _showTime = false;

  void showUserProfile(String userId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return UserProfile(userId: userId);
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            height: _showTime ? 30 : 0,
            child: Padding(
              padding: const EdgeInsets.only(top: Dimens.size12),
              child: Text(
                TimeAgo.getDate(widget.chat.createAt ?? ''),
                style: theme.primaryTextTheme.subtitle2,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: Dimens.size12),
            _buildImageUser(widget.imageUser),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showTime = !_showTime;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: Dimens.size80,
                      top: Dimens.size12,
                      left: Dimens.size8),
                  child: Container(
                      decoration: BoxDecoration(
                        color: theme.shadowColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.size15, vertical: Dimens.size10),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: widget.chat.message ?? '',
                              style: theme.primaryTextTheme.bodyText2,
                            ),
                            TextSpan(
                                text: '   ' +
                                    TimeAgo.getTime(widget.chat.createAt ?? ''),
                                style: theme.textTheme.subtitle2)
                          ]),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageUser(String imageUser) {
    return GestureDetector(
      onTap: () => showUserProfile(widget.chat.userId ?? ''),
      child: SizedBox(
        width: Dimens.size30,
        height: Dimens.size30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: imageUser == ''
              ? Image.asset(
                  MyImages.defaultAvt,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: imageUser,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
