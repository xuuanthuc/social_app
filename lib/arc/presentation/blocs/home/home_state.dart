part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class InitHomeState extends HomeState{}

class HomeLoadingState extends HomeState{}

class HomeLoadedState extends HomeState{
  final List<PostData>? listPost;
  final List<String>? listStory;
  const HomeLoadedState({this.listPost, this.listStory});
}

class OnLikedPostState extends HomeState{
  final PostData post;
  const OnLikedPostState(this.post);
}

class OnDisLikedPostState extends HomeState{
  final PostData post;
  const OnDisLikedPostState(this.post);
}


class OnCommentTextChangedState extends HomeState{
  final String? text;
  const OnCommentTextChangedState(this.text);
}

class OnCommentSuccessState extends HomeState{}

class OnCommentFailedState extends HomeState{}

class LoadingListCommentState extends HomeState{}

class LoadListCommentSuccessState extends HomeState{
  final List<CommentModel>? listComment;
  const LoadListCommentSuccessState(this.listComment);
}

class LoadListCommentFailedState extends HomeState{}

class ReloadingListCommentState extends HomeState{}
