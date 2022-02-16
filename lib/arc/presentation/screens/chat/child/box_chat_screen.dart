import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/chat.dart';
import 'package:hii_xuu_social/arc/presentation/screens/chat/widget/bottom_chat.dart';
import 'package:hii_xuu_social/arc/presentation/screens/chat/widget/item_chat.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/format.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

import '../../profile/user_profile.dart';

class BoxChatScreen extends StatefulWidget {
  final String userId;
  final String? username;
  final String? imageUser;

  const BoxChatScreen(
      {Key? key, required this.userId, this.username, this.imageUser})
      : super(key: key);

  @override
  _BoxChatScreenState createState() => _BoxChatScreenState();
}

class _BoxChatScreenState extends State<BoxChatScreen> {
  final ScrollController _controller = ScrollController();

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
    return Scaffold(
      appBar: _buildAppBar(context, theme),
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(AppConfig.instance.cUser)
                  .doc(StaticVariable.myData?.userId)
                  .collection(AppConfig.instance.cChat)
                  .doc(AppConfig.instance.cListChat)
                  .collection(widget.userId)
                  .orderBy('create_at', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(),
                  );
                }
                return ListView(
                  reverse: true,
                  controller: _controller,
                  physics: const BouncingScrollPhysics(),
                  children:
                      chatSnapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    var _chat = ChatData.fromJson(data);
                    if (_chat.userId != StaticVariable.myData?.userId) {
                      return ItemOtherChat(
                        chat: _chat,
                        imageUser: widget.imageUser ?? '',
                      );
                    } else {
                      return ItemMyChat(chat: _chat);
                    }
                  }).toList(),
                );
              },
            ),
          ),
          BottomChatField(userId: widget.userId),
          const SizedBox(height: Dimens.size5),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(Dimens.size8),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            decoration: BoxDecoration(
              color: theme.primaryColorLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.size12),
              child: Image.asset(MyImages.icBack),
            ),
          ),
        ),
      ),
      centerTitle: false,
      title: GestureDetector(
        onTap: () => showUserProfile(widget.userId),
        child: Row(
          children: [
            _buildImageUser(widget.imageUser ?? ''),
            const SizedBox(width: Dimens.size12),
            Text(
              widget.username ?? '',
              style: theme.textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildImageUser(String imageUser) {
    return SizedBox(
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
    );
  }
}
