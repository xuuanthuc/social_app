part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class InitState extends ProfileState{}

class LoadingInitProfileState extends ProfileState{}

class LoadingClickedFollowState extends ProfileState{}

class InitProfileSuccessState extends ProfileState{
  final UserData user;
  const InitProfileSuccessState(this.user);
}

class OnFollowSuccessState extends ProfileState{}

class OnUnFollowSuccessState extends ProfileState{}
