part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class InitHomeState extends HomeState{}

class HomeLoadedState extends HomeState{}
