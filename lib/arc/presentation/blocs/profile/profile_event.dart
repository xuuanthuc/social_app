part of 'profile_bloc.dart';
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class InitProfileUserEvent extends ProfileEvent {
  final String userId;
  const InitProfileUserEvent(this.userId);
}

class OnFollowClickedEvent extends ProfileEvent{
  final String userId;
  const OnFollowClickedEvent(this.userId);
}

class OnUnFollowClickedEvent extends ProfileEvent{
  final String userId;
  const OnUnFollowClickedEvent(this.userId);
}
