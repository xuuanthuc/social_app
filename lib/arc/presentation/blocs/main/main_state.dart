part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class InitMainState extends MainState{}

class MainLoadedState extends MainState{}