part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class InitHomeEvent extends HomeEvent {}

class OnLikePostEvent extends HomeEvent{
  final PostData post;
  const OnLikePostEvent(this.post);
}

class OnDisLikePostEvent extends HomeEvent{
  final PostData post;
  const OnDisLikePostEvent(this.post);
}

class OnCommentTextChangedEvent extends HomeEvent{
  final String? text;
  const OnCommentTextChangedEvent(this.text);
}

class OnCommentEvent extends HomeEvent{
  final String comment;
  final PostData? post;
  const OnCommentEvent({
    required this.comment,
    required this.post
  });
}

class LoadListComment extends HomeEvent{
  final PostData post;
  const LoadListComment(this.post);
}