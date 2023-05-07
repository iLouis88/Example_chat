import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/repositories/dashboard_repo.dart';
import 'package:savia/repositories/phone_sign_in_repository.dart';

part 'phone_sign_in_event.dart';
part 'phone_sign_in_state.dart';

class PhoneSignInBloc extends Bloc<PhoneSignInEvent, PhoneSignInState> {
  PhoneSignInRepository phoneSignInRepository;
  DashboardRepository dashboardRepository;

  PhoneSignInBloc(
      {required this.phoneSignInRepository, required this.dashboardRepository})
      : super(Init()) {
    on<PhoneSignInSendOTPPhoneNumberEvent>(_sendOtp);
    on<PhoneSignInVerifyOTPEvent>(_verifyOTP);
  }
  Future<void> _sendOtp(PhoneSignInSendOTPPhoneNumberEvent event,
      Emitter<PhoneSignInState> emit) async {
    emit(PhoneSignInLoading());
    try {
      await phoneSignInRepository.sendOtpPhoneNumber(
          phoneNumber: event.phoneNumber, pushToOtp: event.pushToOtp);
      emit(SentOTP());
    } catch (e) {
      emit(PhoneSignInError(error: e.toString()));
      emit(UnSentOTP());
    }
  }

  // verify OTP
  Future<void> _verifyOTP(
      PhoneSignInVerifyOTPEvent event, Emitter<PhoneSignInState> emit) async {
    emit(PhoneSignInLoading());
    try {
      await phoneSignInRepository.verifyOTP(
        smsCode: event.smsCode,
        verificationId: event.verificationId,
        onError: event.onError,
      );
      if (!(await dashboardRepository.checkUserExist())) {
        await dashboardRepository.createNewDataUser();
      }
      emit(VerifiedOTPSuccess());
    } catch (e) {
      emit(PhoneSignInError(error: e.toString()));
    }
  }
}
