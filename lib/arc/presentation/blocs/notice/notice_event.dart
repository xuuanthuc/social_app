part of 'notice_bloc.dart';

abstract class NoticeEvent extends Equatable {
  const NoticeEvent();

  @override
  List<Object> get props => [];
}

class InitNoticeEvent extends NoticeEvent {}

class CommentPostNoticeEvent extends NoticeEvent {
  final String authId;
  final String postId;
  final String userCommentedId;
  const CommentPostNoticeEvent({required this.authId, required this.userCommentedId, required this.postId});
}

class ReactedPostNoticeEvent extends NoticeEvent {
  final String authId;
  final String postId;
  final String userCommentedId;
  const ReactedPostNoticeEvent({required this.authId, required this.userCommentedId, required this.postId});
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

class OnClickMessageNoticeEvent extends NoticeEvent {
  final Map<String, dynamic> data;
  const OnClickMessageNoticeEvent(this.data);
}

class OnClickPostNoticeEvent extends NoticeEvent {
  final Map<String, dynamic> data;
  const OnClickPostNoticeEvent(this.data);
}

class OnClickFollowNoticeEvent extends NoticeEvent {
  final Map<String, dynamic> data;
  const OnClickFollowNoticeEvent(this.data);
}