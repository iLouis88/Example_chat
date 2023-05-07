part of 'sign_out_bloc.dart';

abstract class SignOutState extends Equatable {
  const SignOutState();

  @override
  List<Object> get props => [];
}

class SignOutError extends SignOutState {
  final String error;

  const SignOutError({required this.error});
  @override
  List<Object> get props => [error];
}

class SignedOut extends SignOutState {}

class UnSignedOut extends SignOutState {}
