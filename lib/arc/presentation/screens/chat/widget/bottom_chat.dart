import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/chat/chat_bloc.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';

import '../../../../../src/validators/static_variable.dart';
import '../../../blocs/notice/notice_bloc.dart';

class BottomChatField extends StatefulWidget {
  final String userId;

  const BottomChatField({Key? key, required this.userId}) : super(key: key);

  @override
  _BottomChatFieldState createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _chatController = TextEditingController();
  bool _canSendMess = false;
  bool _isSending = false;
  bool _hasFocus = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(OnDeleteImageEvent());
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    context.read<ChatBloc>().add(OnFocusChangeEvent(_focus.hasFocus));
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
          _imageFile = null;
          _canSendMess = false;
          _hasFocus = false;
          _isSending = false;
        }
        if (state is SendingChatState) {
          _isSending = true;
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is OnFocusChangedState) {
            _hasFocus = state.hasFocus;
          }
          if (state is OnChatTextChangedState) {
            context.read<ChatBloc>().add(const OnFocusChangeEvent(true));
          }
          if (state is ImagePickedState) {
            _imageFile = state.imageFiles;
            _canSendMess = true;
          }
          if (state is OnDeleteImageState) {
            _imageFile = null;
            _canSendMess = false;
          }
          final theme = Theme.of(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _itemMyChat(),
              Padding(
                padding: const EdgeInsets.only(top: Dimens.size5),
                child: Row(
                  crossAxisAlignment: _imageFile == null
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: Dimens.size10),
                    _buildArrowAnimated(context, theme),
                    _buildSelectPhoto(theme),
                    const SizedBox(width: Dimens.size5),
                    _imageFile == null
                        ? _buildTextFieldChat(theme)
                        : _buildImageMessage(context),
                    _buildCommentButton(),
                    const SizedBox(width: Dimens.size15),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageMessage(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 105,
            child: Stack(
              children: [
                SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                      onPressed: () {
                        context.read<ChatBloc>().add(OnDeleteImageEvent());
                      },
                      icon: Icon(Icons.close)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  AnimatedSize _buildSelectPhoto(ThemeData theme) {
    return AnimatedSize(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
      child: Visibility(
        visible: !_hasFocus,
        child: SizedBox(
          width: _hasFocus ? 0 : 75,
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  context.read<ChatBloc>().add(const OnPickImageEvent(false));
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.insert_photo_outlined,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  context.read<ChatBloc>().add(const OnPickImageEvent(true));
                },
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.photo_camera,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 2),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedSize _buildArrowAnimated(BuildContext context, ThemeData theme) {
    return AnimatedSize(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        width: _hasFocus ? 30 : 0,
        child: Visibility(
          visible: _hasFocus,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              context.read<ChatBloc>().add(const OnFocusChangeEvent(false));
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                CupertinoIcons.forward,
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentButton() {
    return AnimatedSize(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
      child: Visibility(
        visible: _canSendMess,
        child: SizedBox(
          height: _canSendMess ? 40 : 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: _canSendMess == true
                ? () {
                    context.read<ChatBloc>().add(
                          SendMessageEvent(
                              message: _chatController.text,
                              msgType: _imageFile == null
                                  ? Constants.msgType.text
                                  : Constants.msgType.image,
                              userId: widget.userId),
                        );
                  }
                : () {},
            child: Padding(
              padding: const EdgeInsets.only(left: Dimens.size15),
              child: SizedBox(
                  width: Dimens.size20,
                  height: Dimens.size20,
                  child: Image.asset(_canSendMess == true
                      ? MyImages.icSend
                      : MyImages.icSendOutline)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldChat(ThemeData theme) {
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
          onTap: () {
            context.read<ChatBloc>().add(const OnFocusChangeEvent(true));
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
                  left: Dimens.size80,
                  top: Dimens.size12,
                  right: Dimens.size12),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: _imageFile == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.size15, vertical: Dimens.size10),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: _chatController.text,
                              style: theme.textTheme.bodyText2,
                            ),
                            TextSpan(
                                text: '   sending...',
                                style: theme.textTheme.caption)
                          ]),
                        ),
                      )
                    : SizedBox(
                        width: Dimens.size150,
                        height: Dimens.size150,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            )),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
