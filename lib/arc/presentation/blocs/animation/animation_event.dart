part of 'animation_bloc.dart';
abstract class AnimationEvent extends Equatable {
  const AnimationEvent();

  @override
  List<Object> get props => [];
}

class IconAddStoryChangeEvent extends AnimationEvent {
  final bool smallIcon;
  const IconAddStoryChangeEvent(this.smallIcon);
}
