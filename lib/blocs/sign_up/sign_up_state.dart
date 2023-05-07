part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpLoading extends SignUpState {}

class SignedUp extends SignUpState {}

class UnSignedUp extends SignUpState {}

class SignUpError extends SignUpState {
  final String error;

  const SignUpError({required this.error});

  @override
  List<Object> get props => [error];
}
