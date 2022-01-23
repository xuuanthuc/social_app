part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SubmitLoginEvent extends AuthEvent {
  final String username;
  final String password;

  const SubmitLoginEvent({required this.password, required this.username});
}

class SubmitRegisterEvent extends AuthEvent{
  final String username;
  final String password;

  const SubmitRegisterEvent({required this.password, required this.username});
}