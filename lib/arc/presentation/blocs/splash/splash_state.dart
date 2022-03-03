part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class InitSplashState extends SplashState{}

class GotoHomeState extends SplashState{}

class GoToLoginState extends SplashState{}

class GoToOnBroadState extends SplashState{}