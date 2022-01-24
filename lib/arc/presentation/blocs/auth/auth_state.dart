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
  const RegisterFailedState(this.error);
}

class RegisterSuccessState extends AuthState{}

class UserExistState extends AuthState{}

class OnChangingState extends AuthState{}

class SubmitUpdateProfileSuccessState extends AuthState{}

class SubmitUpdateProfileFailedState extends AuthState{}

class OnChangedFullNameTextState extends AuthState{
  final String? text;
  const OnChangedFullNameTextState(this.text);
}

class OnChangedBioTextState extends AuthState{
  final String? text;
  const OnChangedBioTextState(this.text);
}

class ImagePickedState extends AuthState{
  final String? imagePath;
  final File? imageFile;
  const ImagePickedState({this.imagePath, this.imageFile});
}
