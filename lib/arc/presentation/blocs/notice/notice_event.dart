part of 'notice_bloc.dart';

abstract class NoticeEvent extends Equatable {
  const NoticeEvent();

  @override
  List<Object> get props => [];
}

class InitNoticeEvent extends NoticeEvent {}

class CommentPostNoticeEvent extends NoticeEvent {
  final String authId;
  final String userCommentedId;
  const CommentPostNoticeEvent({required this.authId, required this.userCommentedId});
}

class ReactedPostNoticeEvent extends NoticeEvent {
  final String authId;
  final String userCommentedId;
  const ReactedPostNoticeEvent({required this.authId, required this.userCommentedId});
}

class ChatMessageNoticeEvent extends NoticeEvent {
  final String userReceiverNoticeId;
  final String userSendMsgId;
  final String message;
  const ChatMessageNoticeEvent({required this.userReceiverNoticeId, required this.userSendMsgId, required this.message});
}

class FollowedNoticeEvent extends NoticeEvent {
  final String authId;
  final String userFollowedId;
  const FollowedNoticeEvent({required this.authId, required this.userFollowedId});
}