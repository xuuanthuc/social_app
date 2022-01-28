import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'animation_event.dart';

part 'animation_state.dart';

class AnimationBloc extends Bloc<AnimationEvent, AnimationState> {
  AnimationBloc() : super(InitAnimationState()) {
    on<IconAddStoryChangeEvent>(_onIconAddStoryChangeEvent);
  }

  void _onIconAddStoryChangeEvent(
    IconAddStoryChangeEvent event,
    Emitter<AnimationState> emit,
  ) async {
    emit(InitAnimationState());
    emit(IconAddStoryChangedState(event.smallIcon));
  }
}
