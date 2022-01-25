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

