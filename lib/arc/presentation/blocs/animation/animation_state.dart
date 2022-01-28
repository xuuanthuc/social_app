part of 'animation_bloc.dart';

abstract class AnimationState extends Equatable {
  const AnimationState();

  @override
  List<Object> get props => [];
}

class IconAddStoryChangedState extends AnimationState{
  final bool smallIcon;
  const IconAddStoryChangedState(this.smallIcon);
}

class InitAnimationState extends AnimationState{}
