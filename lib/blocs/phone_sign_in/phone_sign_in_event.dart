part of 'phone_sign_in_bloc.dart';

abstract class PhoneSignInEvent extends Equatable {
  const PhoneSignInEvent();

  @override
  List<Object> get props => [];
}

// sentOTP
class PhoneSignInSendOTPPhoneNumberEvent extends PhoneSignInEvent {
  final String phoneNumber;
  final void Function(String) pushToOtp;

  const PhoneSignInSendOTPPhoneNumberEvent(
      {required this.phoneNumber, required this.pushToOtp});

  @override
  List<Object> get props => [phoneNumber, pushToOtp];
}

// veriryOTP
class PhoneSignInVerifyOTPEvent extends PhoneSignInEvent {
  final String verificationId;
  final String smsCode;
  final void Function() onError;

  const PhoneSignInVerifyOTPEvent(
      {required this.verificationId,
      required this.smsCode,
      required this.onError});

  @override
  List<Object> get props => [verificationId, smsCode];
}
