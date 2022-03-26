part of 'notice_bloc.dart';

abstract class NoticeState extends Equatable {
  const NoticeState();

  @override
  List<Object> get props => [];
}

class InitNoticeState extends NoticeState{}

class OnClickMessageNoticeState extends NoticeState {
  final UserData user;
  const OnClickMessageNoticeState(this.user);
}

class OnClickPostNoticeState extends NoticeState {
  final PostData post;
  const OnClickPostNoticeState(this.post);
}

class OnClickFollowNoticeState extends NoticeState {
  final String userId;
  const OnClickFollowNoticeState(this.userId);
}