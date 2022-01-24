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

class SubmitRegisterEvent extends AuthEvent {
  final String username;
  final String password;

  const SubmitRegisterEvent({required this.password, required this.username});
}

class OnChangedFullNameTextEvent extends AuthEvent{
  final String? text;
  const OnChangedFullNameTextEvent(this.text);
}
class OnChangedBioTextEvent extends AuthEvent{
  final String? text;
  const OnChangedBioTextEvent(this.text);
}

class OnPickImageEvent extends AuthEvent{}

class SubmitUpdateProfileEvent extends AuthEvent {
  final String? fullName;
  final String? username;
  final String? password;
  final String? tagName;
  final String? email;
  final String? phone;
  final String? imageUrl;
  final String? userId;
  final String? bio;
  final String? createAt;
  final String? updateAt;

  const SubmitUpdateProfileEvent({
    this.password,
    this.username,
    this.userId,
    this.updateAt,
    this.imageUrl,
    this.tagName,
    this.createAt,
    this.fullName,
    this.email,
    this.phone,
    this.bio,
  });
}
