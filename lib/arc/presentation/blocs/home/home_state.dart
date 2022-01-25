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
  const HomeLoadedState(this.listPost);
}

class OnLikedPostState extends HomeState{
  final PostData post;
  const OnLikedPostState(this.post);
}

class OnDisLikedPostState extends HomeState{
  final PostData post;
  const OnDisLikedPostState(this.post);
}
