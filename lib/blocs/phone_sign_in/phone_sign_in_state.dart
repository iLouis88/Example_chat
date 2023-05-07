part of 'phone_sign_in_bloc.dart';

abstract class PhoneSignInState extends Equatable {
  const PhoneSignInState();

  @override
  List<Object> get props => [];
}

class Init extends PhoneSignInState {}

class UnSentOTP extends PhoneSignInState {}

class SentOTP extends PhoneSignInState {}

class VerifiedOTPSuccess extends PhoneSignInState {}

class PhoneSignInLoading extends PhoneSignInState {}

class PhoneSignInError extends PhoneSignInState {
  final String error;
  const PhoneSignInError({required this.error});
  @override
  List<Object> get props => [error];
}
