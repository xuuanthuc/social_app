part of 'chat_bloc.dart';
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String message;
  final String userId;
  // final String? username;
  // final String? imageUser;
  const SendMessageEvent({required this.message, required this.userId});
}

class OnChatTextChangedEvent extends ChatEvent{
  final String? text;
  const OnChatTextChangedEvent(this.text);
}

class LoadListRoomChatEvent extends ChatEvent {}
