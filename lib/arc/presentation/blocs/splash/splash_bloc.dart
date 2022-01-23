import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(InitSplashState()) {
    on<InitSplashEvent>(_onInitialSplashEvent);
  }

  void _onInitialSplashEvent(
      InitSplashEvent event,
      Emitter<SplashState> emit,
      ) async {
    emit(SplashLoadedState());
  }
}