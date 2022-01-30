import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/chat/chat_bloc.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';

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
          _chatController.clear();
          _canSendMess = false;
          _focus.unfocus();
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          return Row(
            children: [
              const SizedBox(width: Dimens.size15),
              _buildTextFieldChat(theme),
              _buildCommentButton(),
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
}
