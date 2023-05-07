part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInLoading extends SignInState {}

class SignedIn extends SignInState {}

class UnSignedIn extends SignInState {}

class SignInError extends SignInState {
  final String error;

  const SignInError({required this.error});
  @override
  List<Object> get props => [error];
}
