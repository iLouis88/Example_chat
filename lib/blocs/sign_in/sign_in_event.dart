part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

// email and password
class SignInWithEmailAndPasswordEvent extends SignInEvent {
  final String email;
  final String password;

  const SignInWithEmailAndPasswordEvent(
      {required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

// google
class SignInWithGoogleEvent extends SignInEvent {}

class SignInResetPasswordEvent extends SignInEvent {
  final String email;

  const SignInResetPasswordEvent({required this.email});
  @override
  List<Object> get props => [email];
}
