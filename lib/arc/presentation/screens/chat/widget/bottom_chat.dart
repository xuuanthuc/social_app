import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/chat/chat_bloc.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';

import '../../../../../src/validators/static_variable.dart';
import '../../../blocs/notice/notice_bloc.dart';

class BottomChatField extends StatefulWidget {
  final String userId;

  const BottomChatField(
      {Key? key, required this.userId})
      : super(key: key);

  @override
  _BottomChatFieldState createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _chatController = TextEditingController();
  bool _canSendMess = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _chatController.dispose();
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is OnChatTextChangedState) {
          if (_chatController.text.trim().isNotEmpty) {
            _canSendMess = true;
          } else {
            _canSendMess = false;
          }
        }
        if (state is SendMessageSuccessState) {
          context.read<NoticeBloc>().add(ChatMessageNoticeEvent(
              userSendMsgId: StaticVariable.myData?.userId ?? '',
              message: _chatController.text,
              userReceiverNoticeId: widget.userId));
          _chatController.clear();
          _canSendMess = false;
          _isSending = false;
        }
        if(state is SendingChatState){
          _isSending = true;
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _itemMyChat(),
              Padding(
                padding: const EdgeInsets.only(top: Dimens.size3),
                child: Row(
                  children: [
                    const SizedBox(width: Dimens.size15),
                    _buildTextFieldChat(theme),
                    _buildCommentButton(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCommentButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: _canSendMess == true
          ? () {
              context.read<ChatBloc>().add(
                    SendMessageEvent(
                        message: _chatController.text, userId: widget.userId),
                  );
            }
          : () {},
      child: Padding(
        padding: const EdgeInsets.all(Dimens.size15),
        child: SizedBox(
            width: Dimens.size20,
            height: Dimens.size20,
            child: Image.asset(_canSendMess == true
                ? MyImages.icSend
                : MyImages.icSendOutline)),
      ),
    );
  }

  Expanded _buildTextFieldChat(ThemeData theme) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: TextField(
          focusNode: _focus,
          style: theme.textTheme.headline6,
          controller: _chatController,
          cursorHeight: Dimens.size18,
          onChanged: (value) {
            context.read<ChatBloc>().add(OnChatTextChangedEvent(value));
          },
          decoration: InputDecoration(
            hintText: _focus.hasFocus ? 'Enter message...' : 'Aa',
            hintStyle: theme.primaryTextTheme.subtitle1,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: Dimens.size20, vertical: Dimens.size4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.shadowColor,
          ),
        ),
      ),
    );
  }

  Widget _itemMyChat() {
    // final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Visibility(
      visible: _isSending,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
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
                    text: TextSpan(
                        children: [
                          TextSpan(text: _chatController.text,
                            style: theme.textTheme.bodyText2,),
                          TextSpan(text: '   sending...',
                              style: theme.textTheme.caption)
                        ]
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
