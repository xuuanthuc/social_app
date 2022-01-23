part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class InitAuthState extends AuthState{}

class LoadingLoginState extends AuthState{}

class LoginFailedState extends AuthState{}

class LoginSuccessState extends AuthState{}

class RegisterFailedState extends AuthState{
  final String? error;
  RegisterFailedState(this.error);
}

class RegisterSuccessState extends AuthState{}

class UserExistState extends AuthState{}