part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class InitMainEvent extends MainEvent {}

class OnChangePageEvent extends MainEvent {
  final int index;
  const OnChangePageEvent(this.index);
}
