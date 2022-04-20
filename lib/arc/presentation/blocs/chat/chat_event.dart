part of 'chat_bloc.dart';
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String message;
  final String userId;
  final int msgType;
  // final String? username;
  // final String? imageUser;
  const SendMessageEvent({required this.message, required this.userId, required this.msgType});
}

class OnChatTextChangedEvent extends ChatEvent{
  final String? text;
  const OnChatTextChangedEvent(this.text);
}

class LoadListRoomChatEvent extends ChatEvent {}

class OnFocusChangeEvent extends ChatEvent {
  final bool hasFocus;
  const OnFocusChangeEvent(this.hasFocus);
}

class OnPickImageEvent extends ChatEvent{
  final bool isOpenCamera;
  const OnPickImageEvent(this.isOpenCamera);
}

class OnDeleteImageEvent extends ChatEvent{}