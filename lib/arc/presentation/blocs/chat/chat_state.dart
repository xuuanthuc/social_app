part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class InitChatState extends ChatState{}

class SendingChatState extends ChatState{}

class SendMessageSuccessState extends ChatState{}

class LoadingRoomChatState extends ChatState{}

class LoadListRoomChatSuccessState extends ChatState{
  final List<UserData> listRoomChat;
  final List<UserData> listSuggetUser;
  const LoadListRoomChatSuccessState(this.listRoomChat, this.listSuggetUser);
}

class OnChatTextChangedState extends ChatState{
  final String? text;
  const OnChatTextChangedState(this.text);
}

class OnFocusChangedState extends ChatState {
  final bool hasFocus;
  const OnFocusChangedState(this.hasFocus);
}

class ImagePickedState extends ChatState{
  final File? imageFiles;
  const ImagePickedState({this.imageFiles});
}

class OnDeleteImageState extends ChatState{}